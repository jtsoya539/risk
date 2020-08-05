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

using System.Collections.Generic;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Risk.Msj
{
    public class RiskAPIClientConnection : IRiskAPIClientConnection
    {
        private readonly ILogger<RiskAPIClientConnection> _logger;
        private readonly IConfiguration _configuration;

        // Risk Configuration
        private readonly Configuration _apiConfiguration;
        private readonly IAutApi _autApi;
        private readonly IMsjApi _msjApi;
        private string accessToken;
        private string refreshToken;

        public RiskAPIClientConnection(ILogger<RiskAPIClientConnection> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;

            // Risk Configuration
            _apiConfiguration = new Configuration();
            _apiConfiguration.BasePath = _configuration["RiskConfiguration:RiskAPIBasePath"];
            _apiConfiguration.ApiKey.Add("Risk-App-Key", _configuration["RiskConfiguration:RiskAppKey"]);

            _autApi = new AutApi(_apiConfiguration);
            _msjApi = new MsjApi(_apiConfiguration);

            IniciarSesion();
        }

        public void IniciarSesion()
        {
            SesionRespuesta sesionRespuesta = _autApi.IniciarSesion(new IniciarSesionRequestBody
            {
                Usuario = _configuration["RiskConfiguration:Usuario"],
                Clave = _configuration["RiskConfiguration:Clave"]
            });

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                accessToken = sesionRespuesta.Datos.AccessToken;
                refreshToken = sesionRespuesta.Datos.RefreshToken;
            }

            _apiConfiguration.AccessToken = accessToken;

            _msjApi.Configuration = _apiConfiguration;
        }

        public void RefrescarSesion()
        {
            SesionRespuesta sesionRespuesta = _autApi.RefrescarSesion(new RefrescarSesionRequestBody
            {
                AccessToken = accessToken,
                RefreshToken = refreshToken
            });

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                accessToken = sesionRespuesta.Datos.AccessToken;
                refreshToken = sesionRespuesta.Datos.RefreshToken;
            }

            _apiConfiguration.AccessToken = accessToken;

            _msjApi.Configuration = _apiConfiguration;
        }

        public void CambiarEstadoMensajeria(TipoMensajeria tipo, int id, EstadoMensajeria estado, string respuestaEnvio)
        {
            DatoRespuesta datoRespuesta = new DatoRespuesta();
            try
            {
                datoRespuesta = _msjApi.CambiarEstadoMensajeria(new CambiarEstadoMensajeriaRequestBody
                {
                    TipoMensajeria = tipo,
                    IdMensajeria = id,
                    Estado = estado,
                    RespuestaEnvio = respuestaEnvio
                });
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        datoRespuesta = _msjApi.CambiarEstadoMensajeria(new CambiarEstadoMensajeriaRequestBody
                        {
                            TipoMensajeria = tipo,
                            IdMensajeria = id,
                            Estado = estado,
                            RespuestaEnvio = respuestaEnvio
                        });
                    }
                    catch (ApiException ex)
                    {
                        _logger.LogError($"Error al cambiar estado de envío de la mensajería: {ex.Message}");
                    }
                }
            }
        }

        public List<Correo> ListarCorreosPendientes()
        {
            List<Correo> mensajes = new List<Correo>();

            CorreoPaginaRespuesta mensajesPendientes = null;
            try
            {
                mensajesPendientes = _msjApi.ListarCorreosPendientes(null, null, "S");
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        mensajesPendientes = _msjApi.ListarCorreosPendientes(null, null, "S");
                    }
                    catch (ApiException ex)
                    {
                        _logger.LogError($"Error al obtener lista de correos pendientes: {ex.Message}");
                    }
                }
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals("0") && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }

        public List<Notificacion> ListarNotificacionesPendientes()
        {
            List<Notificacion> mensajes = new List<Notificacion>();

            NotificacionPaginaRespuesta mensajesPendientes = null;
            try
            {
                mensajesPendientes = _msjApi.ListarNotificacionesPendientes(null, null, "S");
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        mensajesPendientes = _msjApi.ListarNotificacionesPendientes(null, null, "S");
                    }
                    catch (ApiException ex)
                    {
                        _logger.LogError($"Error al obtener lista de notificaciones pendientes: {ex.Message}");
                    }
                }
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals("0") && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }

        public List<Mensaje> ListarMensajesPendientes()
        {
            List<Mensaje> mensajes = new List<Mensaje>();

            MensajePaginaRespuesta mensajesPendientes = null;
            try
            {
                mensajesPendientes = _msjApi.ListarMensajesPendientes(null, null, "S");
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        mensajesPendientes = _msjApi.ListarMensajesPendientes(null, null, "S");
                    }
                    catch (ApiException ex)
                    {
                        _logger.LogError($"Error al obtener lista de mensajes pendientes: {ex.Message}");
                    }
                }
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals("0") && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }
    }
}