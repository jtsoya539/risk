using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Risk.API.Client.Model;

namespace Risk.Msj
{
    public class WorkerPush : BackgroundService
    {
        private readonly ILogger<WorkerPush> _logger;
        private readonly IConfiguration _configuration;

        // Risk Configuration
        private readonly IRiskAPIClientConnection _riskAPIClientConnection;

        // Notification Hub Configuration
        private NotificationHubClient hubClient;

        public WorkerPush(ILogger<WorkerPush> logger, IConfiguration configuration, IRiskAPIClientConnection riskAPIClientConnection)
        {
            _logger = logger;
            _configuration = configuration;

            // Risk Configuration
            _riskAPIClientConnection = riskAPIClientConnection;
        }

        // Notification Hub Configuration
        private void Configurar()
        {
            hubClient = NotificationHubClient.CreateClientFromConnectionString(
                _configuration["NotificationHubConfiguration:ConnectionString"],
                _configuration["NotificationHubConfiguration:NotificationHubPath"]
            );
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                if (_configuration.GetValue<bool>("EnablePush"))
                {
                    _logger.LogInformation($"WorkerPush running at: {DateTimeOffset.Now}");

                    var mensajes = _riskAPIClientConnection.ListarNotificacionesPendientes();

                    if (mensajes.Any())
                    {
                        // Notification Hub Configuration
                        Configurar();

                        foreach (var item in mensajes)
                        {
                            try
                            {
                                var properties = new Dictionary<string, string> { { "titulo", item.Titulo }, { "contenido", item.Contenido } };
                                await hubClient.SendTemplateNotificationAsync(properties, item.Suscripcion);

                                // Cambia estado de la mensajería a E-ENVIADO
                                _riskAPIClientConnection.CambiarEstadoMensajeria(TipoMensajeria.Push, item.IdNotificacion, EstadoMensajeria.Enviado, "OK");
                            }
                            catch (Exception e)
                            {
                                // Cambia estado de la mensajería a R-PROCESADO CON ERROR
                                _riskAPIClientConnection.CambiarEstadoMensajeria(TipoMensajeria.Push, item.IdNotificacion, EstadoMensajeria.ProcesadoError, e.Message);
                            }
                        }
                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(_configuration.GetValue<double>("ExecuteDelaySeconds")), stoppingToken);
            }
        }
    }
}