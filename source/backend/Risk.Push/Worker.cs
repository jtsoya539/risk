using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Risk.Push
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

        // Notification Hub Configuration
        private readonly NotificationHubClient _hubClient;

        public Worker(ILogger<Worker> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;

            // Risk Configuration
            apiConfiguration = new Configuration();
            apiConfiguration.BasePath = _configuration["RiskConfiguration:RiskAPIBasePath"];
            apiConfiguration.ApiKey.Add("Risk-App-Key", _configuration["RiskConfiguration:RiskAppKey"]);

            autApi = new AutApi(apiConfiguration);
            msjApi = new MsjApi(apiConfiguration);

            IniciarSesion();

            // Notification Hub Configuration
            string connectionString = _configuration["NotificationHubConfiguration:ConnectionString"];
            string notificationHubPath = _configuration["NotificationHubConfiguration:NotificationHubPath"];
            _hubClient = NotificationHubClient.CreateClientFromConnectionString(connectionString, notificationHubPath);
        }

        private void IniciarSesion()
        {
            SesionRespuesta sesionRespuesta = autApi.IniciarSesion(new IniciarSesionRequestBody
            {
                Usuario = _configuration["RiskConfiguration:Usuario"],
                Clave = _configuration["RiskConfiguration:Clave"]
            });

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                accessToken = sesionRespuesta.Datos.AccessToken;
                refreshToken = sesionRespuesta.Datos.RefreshToken;
            }

            apiConfiguration.AccessToken = accessToken;

            msjApi.Configuration = apiConfiguration;
        }

        private void RefrescarSesion()
        {
            SesionRespuesta sesionRespuesta = autApi.RefrescarSesion(new RefrescarSesionRequestBody
            {
                AccessToken = accessToken,
                RefreshToken = refreshToken
            });

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                accessToken = sesionRespuesta.Datos.AccessToken;
                refreshToken = sesionRespuesta.Datos.RefreshToken;
            }

            apiConfiguration.AccessToken = accessToken;

            msjApi.Configuration = apiConfiguration;
        }

        private List<Notificacion> ListarNotificacionesPendientes()
        {
            List<Notificacion> mensajes = new List<Notificacion>();

            NotificacionPaginaRespuesta mensajesPendientes = null;
            try
            {
                mensajesPendientes = msjApi.ListarNotificacionesPendientes(null, null, "S");
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        mensajesPendientes = msjApi.ListarNotificacionesPendientes(null, null, "S");
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

        private void CambiarEstadoMensajeria(int idMensajeria, string estado, string respuestaEnvio)
        {
            DatoRespuesta datoRespuesta = new DatoRespuesta();
            try
            {
                datoRespuesta = msjApi.CambiarEstadoMensajeria(new CambiarEstadoMensajeriaRequestBody
                {
                    TipoMensajeria = "P", // Push
                    IdMensajeria = idMensajeria,
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
                        datoRespuesta = msjApi.CambiarEstadoMensajeria(new CambiarEstadoMensajeriaRequestBody
                        {
                            TipoMensajeria = "P", // Push
                            IdMensajeria = idMensajeria,
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

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation($"Worker running at: {DateTimeOffset.Now}");

                var mensajes = ListarNotificacionesPendientes();

                if (mensajes.Any())
                {
                    foreach (var item in mensajes)
                    {
                        try
                        {
                            var properties = new Dictionary<string, string> { { "titulo", item.Titulo }, { "contenido", item.Contenido } };
                            await _hubClient.SendTemplateNotificationAsync(properties, item.Suscripcion);

                            // Cambia estado de la mensajería a E-ENVIADO
                            CambiarEstadoMensajeria(item.IdNotificacion, "E", "OK");
                        }
                        catch (Exception e)
                        {
                            // Cambia estado de la mensajería a R-PROCESADO CON ERROR
                            CambiarEstadoMensajeria(item.IdNotificacion, "R", e.Message);
                        }
                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(_configuration.GetValue<double>("ExecuteDelaySeconds")), stoppingToken);
            }
        }
    }
}
