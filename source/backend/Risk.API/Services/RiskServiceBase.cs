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
using System.IO;
using System.Runtime.CompilerServices;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Risk.API.Entities;
using Risk.API.Exceptions;
using Risk.API.Helpers;

namespace Risk.API.Services
{
    public class RiskServiceBase
    {
        protected readonly ILogger<RiskServiceBase> _logger;
        protected readonly IConfiguration _configuration;
        protected readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IDbConnectionFactory _dbConnectionFactory;
        private const string SQL_PROCESAR_SERVICIO = "K_SERVICIO.F_PROCESAR_SERVICIO";
        private const string SQL_PROCESAR_REPORTE = "K_REPORTE.F_PROCESAR_REPORTE";

        public RiskServiceBase(ILogger<RiskServiceBase> logger, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
        {
            _logger = logger;
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor;
            _dbConnectionFactory = dbConnectionFactory;
        }

        private string ObtenerContexto()
        {
            JObject ctx = new JObject();

            // direccion_ip
            string direccionIp = _httpContextAccessor.HttpContext.Connection.RemoteIpAddress.MapToIPv4().ToString();

            // clave_aplicacion
            string claveAplicacion = TokenHelper.ObtenerClaveAplicacionDeHeaders(_httpContextAccessor.HttpContext.Request.Headers);

            // access_token
            string accessToken = TokenHelper.ObtenerAccessTokenDeHeaders(_httpContextAccessor.HttpContext.Request.Headers);

            // usuario
            string usuario = TokenHelper.ObtenerUsuarioDeAccessToken(accessToken);

            ctx.Add("direccion_ip", direccionIp);
            ctx.Add("clave_aplicacion", claveAplicacion);
            ctx.Add("access_token", accessToken);
            ctx.Add("usuario", usuario);

            return ctx.ToString(Formatting.None);
        }

        public string ProcesarOperacion(string tipo, string nombre, string dominio, string parametros, [CallerFilePath] string callerFilePath = "", [CallerMemberName] string callerMemberName = "")
        {
            string respuesta = string.Empty;
            if (tipo != null && nombre != null && dominio != null)
            {
                using (OracleConnection con = (OracleConnection)_dbConnectionFactory.CreateConnection())
                {
                    try
                    {
                        if (con.State != ConnectionState.Open)
                        {
                            con.Open();
                        }

                        // SetApplicationContext
                        con.ClientId = _configuration["SwaggerConfiguration:Title"];
                        con.ClientInfo = _configuration["SwaggerConfiguration:Description"];
                        con.ModuleName = Path.GetFileNameWithoutExtension(callerFilePath);
                        con.ActionName = callerMemberName;

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

                            string contexto = ObtenerContexto();
                            iContexto.Write(contexto.ToCharArray(), 0, contexto.Length);

                            cmd.Parameters.Add("result", OracleDbType.Clob, result, ParameterDirection.ReturnValue);
                            cmd.Parameters.Add("i_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input);
                            cmd.Parameters.Add("i_dominio", OracleDbType.Varchar2, dominio, ParameterDirection.Input);
                            cmd.Parameters.Add("i_parametros", OracleDbType.Clob, iParametros, ParameterDirection.Input);
                            cmd.Parameters.Add("i_contexto", OracleDbType.Clob, iContexto, ParameterDirection.Input);

                            _logger.LogInformation($"Ejecutando el SP [{cmd.CommandText}] con parámetros i_nombre=[{nombre}], i_dominio=[{dominio}], i_parametros=[{parametros}], i_contexto=[{contexto}]");
                            cmd.ExecuteNonQuery();

                            result = (OracleClob)cmd.Parameters["result"].Value;
                            respuesta = result.Value;
                            _logger.LogInformation($"El SP [{cmd.CommandText}] retornó [{respuesta}]");

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
    }
}