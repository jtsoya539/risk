using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace Risk.SMS
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _configuration;

        // Risk Configuration
        private readonly Configuration apiConfiguration;
        private readonly IAutApi autApi;
        private readonly IMsjApi msjApi;
        private string accessToken;
        private string refreshToken;

        // Twilio Configuration
        private readonly string phoneNumberFrom;

        public Worker(ILogger<Worker> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;

            // Risk Configuration
            apiConfiguration = new Configuration();
            apiConfiguration.BasePath = _configuration["RiskConfiguration:RiskAPIBasePath"];
            apiConfiguration.AddApiKeyPrefix("Authorization", "Bearer");

            autApi = new AutApi(apiConfiguration);
            msjApi = new MsjApi(apiConfiguration);

            IniciarSesion();

            // Twilio Configuration
            phoneNumberFrom = _configuration["TwilioConfiguration:PhoneNumberFrom"];

            TwilioClient.Init(_configuration["TwilioConfiguration:AccountSid"], _configuration["TwilioConfiguration:AuthToken"]);
        }

        private void IniciarSesion()
        {
            SesionRespuesta sesionRespuesta = autApi.IniciarSesion(_configuration["RiskConfiguration:RiskAppKey"], new IniciarSesionRequestBody
            {
                Usuario = _configuration["RiskConfiguration:Usuario"],
                Clave = _configuration["RiskConfiguration:Clave"]
            });

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                accessToken = sesionRespuesta.Datos.AccessToken;
                refreshToken = sesionRespuesta.Datos.RefreshToken;
            }

            apiConfiguration.AddApiKey("Authorization", accessToken);

            msjApi.Configuration = apiConfiguration;
        }

        private void RefrescarSesion()
        {
            SesionRespuesta sesionRespuesta = autApi.RefrescarSesion(_configuration["RiskConfiguration:RiskAppKey"], new RefrescarSesionRequestBody
            {
                AccessToken = accessToken,
                RefreshToken = refreshToken
            });

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                accessToken = sesionRespuesta.Datos.AccessToken;
                refreshToken = sesionRespuesta.Datos.RefreshToken;
            }

            apiConfiguration.AddApiKey("Authorization", accessToken);

            msjApi.Configuration = apiConfiguration;
        }

        private List<Mensaje> ListarMensajesPendientes()
        {
            List<Mensaje> mensajes = new List<Mensaje>();

            MensajePaginaRespuesta mensajesPendientes = null;
            try
            {
                mensajesPendientes = msjApi.ListarMensajesPendientes(_configuration["RiskConfiguration:RiskAppKey"], null, null, "S");
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        mensajesPendientes = msjApi.ListarMensajesPendientes(_configuration["RiskConfiguration:RiskAppKey"], null, null, "S");
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

        private void CambiarEstadoMensaje(int idMensaje, string estado, string respuestaEnvio)
        {
            DatoRespuesta datoRespuesta = new DatoRespuesta();
            try
            {
                datoRespuesta = msjApi.CambiarEstadoMensaje(_configuration["RiskConfiguration:RiskAppKey"], new CambiarEstadoMensajeRequestBody
                {
                    IdMensaje = idMensaje,
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
                        datoRespuesta = msjApi.CambiarEstadoMensaje(_configuration["RiskConfiguration:RiskAppKey"], new CambiarEstadoMensajeRequestBody
                        {
                            IdMensaje = idMensaje,
                            Estado = estado,
                            RespuestaEnvio = respuestaEnvio
                        });
                    }
                    catch (ApiException ex)
                    {
                        _logger.LogError($"Error al cambiar estado del mensaje: {ex.Message}");
                    }
                }
            }
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation($"Worker running at: {DateTimeOffset.Now}");

                List<Mensaje> mensajes = ListarMensajesPendientes();

                foreach (var item in mensajes)
                {
                    try
                    {
                        var message = MessageResource.Create(
                            from: new PhoneNumber(phoneNumberFrom),
                            to: new PhoneNumber(item.NumeroTelefono),
                            body: item.Contenido
                        );

                        // Cambia estado del mensaje a E-ENVIADO
                        CambiarEstadoMensaje(item.IdMensaje, "E", JsonConvert.SerializeObject(message));
                    }
                    catch (Twilio.Exceptions.ApiException e)
                    {
                        // Cambia estado del mensaje a R-PROCESADO CON ERROR
                        CambiarEstadoMensaje(item.IdMensaje, "R", e.Message);
                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
            }
        }
    }
}
