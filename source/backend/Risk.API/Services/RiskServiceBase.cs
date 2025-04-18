/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 jtsoya539

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-------------------------------------------------------------------------------
*/

using System;
using System.Data;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Risk.API.Attributes;
using Risk.API.Exceptions;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services.Settings;
using Risk.Common.Helpers;

namespace Risk.API.Services
{
    public class RiskServiceBase : IServiceBase
    {
        public string Version { get; set; }
        protected JObject prms;
        protected JObject rsp;
        protected readonly ILogger<RiskServiceBase> _logger;
        protected readonly ISettingsService _settingsService;
        protected readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IDbConnectionFactory _dbConnectionFactory;
        private const string SQL_PROCESAR_SERVICIO = "K_SERVICIO.F_PROCESAR_SERVICIO";
        private const string SQL_PROCESAR_REPORTE = "K_REPORTE.F_PROCESAR_REPORTE";

        public RiskServiceBase(ILogger<RiskServiceBase> logger, ISettingsService settingsService, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
        {
            _logger = logger;
            _settingsService = settingsService;
            _httpContextAccessor = httpContextAccessor;
            _dbConnectionFactory = dbConnectionFactory;
        }

        protected JObject ObtenerContexto()
        {
            JObject ctx = new JObject();

            string direccionIp = string.Empty; // direccion_ip
            string claveAplicacion = string.Empty; // clave_aplicacion
            string accessToken = string.Empty; // access_token
            string usuario = string.Empty; // usuario
            string tokenDispositivo = string.Empty; // token_dispositivo
            string idEjecucion = string.Empty; // id_ejecucion

            if (_httpContextAccessor.HttpContext != null)
            {
                try
                {
                    direccionIp = _httpContextAccessor.HttpContext.Connection.RemoteIpAddress.MapToIPv4().ToString();
                    claveAplicacion = TokenHelper.ObtenerValorParametroDeHeaders(_httpContextAccessor.HttpContext.Request.Headers, RiskConstants.HEADER_RISK_APP_KEY);
                    accessToken = TokenHelper.ObtenerAccessTokenDeHeaders(_httpContextAccessor.HttpContext.Request.Headers);
                    usuario = TokenHelper.ObtenerUsuarioDeAccessToken(accessToken);
                    tokenDispositivo = TokenHelper.ObtenerValorParametroDeHeaders(_httpContextAccessor.HttpContext.Request.Headers, RiskConstants.HEADER_RISK_DEVICE_TOKEN);
                    idEjecucion = Activity.Current?.Id ?? _httpContextAccessor.HttpContext.TraceIdentifier;
                }
                catch (Exception ex)
                {
                    _logger.LogDebug($"Error al obtener contexto: {ex.Message}");
                }
            }

            ctx.Add("direccion_ip", direccionIp);
            ctx.Add("clave_aplicacion", claveAplicacion);
            ctx.Add("access_token", accessToken);
            ctx.Add("usuario", usuario);
            ctx.Add("token_dispositivo", tokenDispositivo);
            ctx.Add("id_ejecucion", idEjecucion);

            return ctx;
        }

        protected string ObtenerVersion()
        {
            string version = string.Empty;

            if (Version != null)
            {
                version = Version;
                Version = null;
            }
            else
            {
                if (_httpContextAccessor.HttpContext != null)
                {
                    try
                    {
                        version = TokenHelper.ObtenerValorParametroDeHeaders(_httpContextAccessor.HttpContext.Request.Headers, RiskConstants.HEADER_RISK_SERVICE_VERSION);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogDebug($"Error al obtener versión: {ex.Message}");
                    }
                }
            }

            return version;
        }

        protected string ProcesarOperacion(string tipo, string nombre, string dominio, string parametros, [CallerFilePath] string callerFilePath = "", [CallerMemberName] string callerMemberName = "")
        {
            string respuesta = string.Empty;
            if (tipo != null && nombre != null && dominio != null)
            {
                using (OracleConnection con = (OracleConnection)_dbConnectionFactory.CreateConnection(this.GetType().Name))
                {
                    try
                    {
                        if (con.State != ConnectionState.Open)
                        {
                            con.Open();
                        }

                        JObject ctx = ObtenerContexto();

                        // SetApplicationContext
                        con.ModuleName = dominio;
                        con.ActionName = nombre;
                        con.ClientId = ctx.Value<string>("id_ejecucion");

                        using (OracleCommand cmd = con.CreateCommand())
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.BindByName = true;
                            switch (tipo)
                            {
                                case "S":
                                    cmd.CommandText = SQL_PROCESAR_SERVICIO;
                                    break;
                                case "R":
                                    cmd.CommandText = SQL_PROCESAR_REPORTE;
                                    break;
                                default:
                                    cmd.CommandText = string.Empty;
                                    break;
                            }

                            OracleClob result = new OracleClob(con);
                            OracleClob iParametros = new OracleClob(con);
                            OracleClob iContexto = new OracleClob(con);

                            iParametros.Write(parametros.ToCharArray(), 0, parametros.Length);

                            string contexto = ctx.ToString(Formatting.None);
                            iContexto.Write(contexto.ToCharArray(), 0, contexto.Length);

                            string version = ObtenerVersion();

                            cmd.Parameters.Add("result", OracleDbType.Clob, result, ParameterDirection.ReturnValue);
                            cmd.Parameters.Add("i_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input);
                            cmd.Parameters.Add("i_dominio", OracleDbType.Varchar2, dominio, ParameterDirection.Input);
                            cmd.Parameters.Add("i_parametros", OracleDbType.Clob, iParametros, ParameterDirection.Input);
                            cmd.Parameters.Add("i_contexto", OracleDbType.Clob, iContexto, ParameterDirection.Input);
                            cmd.Parameters.Add("i_version", OracleDbType.Varchar2, version, ParameterDirection.Input);

                            _logger.LogDebug("Ejecutando el SP [{0}] con parámetros i_nombre=[{1}], i_dominio=[{2}], i_parametros=[{3}], i_contexto=[{4}], i_version=[{5}]",
                                cmd.CommandText,
                                nombre,
                                dominio,
                                parametros,
                                contexto,
                                version);
                            cmd.ExecuteNonQuery();

                            result = (OracleClob)cmd.Parameters["result"].Value;
                            respuesta = EncodingHelper.ConvertToUTF8(result.Value, _settingsService.OracleConfigurationCharacterSet);
                            _logger.LogDebug("El SP [{0}] retornó [{1}]", cmd.CommandText, respuesta);

                            result.Dispose();
                            iParametros.Dispose();
                            iContexto.Dispose();
                        }

                        con.Close();
                    }
                    catch (OracleException oe)
                    {
                        throw new RiskDbException("Operación no disponible o con error", oe);
                    }
                }
            }
            return respuesta;
        }

        protected JObject ProcesarOperacion(TipoOperacion tipo, string nombre, string dominio, JObject parametros, [CallerFilePath] string callerFilePath = "", [CallerMemberName] string callerMemberName = "")
        {
            string respuesta = ProcesarOperacion(tipo.GetStringValue(), nombre, dominio, parametros.ToString(Formatting.None), callerFilePath, callerMemberName);
            return JObject.Parse(respuesta);
        }
    }
}