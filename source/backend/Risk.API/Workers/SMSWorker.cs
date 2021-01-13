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
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Risk.API.Helpers;
using Risk.API.Models;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace Risk.API.Workers
{
    public class SMSWorker : BackgroundService
    {
        private readonly ILogger<SMSWorker> _logger;
        private readonly IConfiguration _configuration;
        private readonly IMsjHelper _msjHelper;

        // Twilio Configuration
        private string phoneNumberFrom;

        public SMSWorker(ILogger<SMSWorker> logger, IConfiguration configuration, IMsjHelper msjHelper)
        {
            _logger = logger;
            _configuration = configuration;
            _msjHelper = msjHelper;
        }

        // Twilio Configuration
        private void Configurar()
        {
            phoneNumberFrom = _configuration["TwilioConfiguration:PhoneNumberFrom"];

            TwilioClient.Init(_configuration["TwilioConfiguration:AccountSid"], _configuration["TwilioConfiguration:AuthToken"]);
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                if (_configuration.GetValue<bool>("EnableSMS") && _msjHelper.MensajeriaActiva)
                {
                    _logger.LogInformation($"SMSWorker running at: {DateTimeOffset.Now}");

                    var mensajes = _msjHelper.ListarMensajesPendientes();

                    if (mensajes.Any())
                    {
                        // Twilio Configuration
                        Configurar();

                        foreach (var item in mensajes)
                        {
                            try
                            {
                                var message = MessageResource.Create(
                                    from: new PhoneNumber(phoneNumberFrom),
                                    to: new PhoneNumber(item.NumeroTelefono),
                                    body: item.Contenido
                                );

                                // Cambia estado de la mensajería a E-ENVIADO
                                _msjHelper.CambiarEstadoMensajeria(TipoMensajeria.SMS, item.IdMensaje, EstadoMensajeria.Enviado, JsonConvert.SerializeObject(message));
                            }
                            catch (Twilio.Exceptions.ApiException e)
                            {
                                // Cambia estado de la mensajería a R-PROCESADO CON ERROR
                                _msjHelper.CambiarEstadoMensajeria(TipoMensajeria.SMS, item.IdMensaje, EstadoMensajeria.ProcesadoError, e.Message);
                            }
                        }
                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(_configuration.GetValue<double>("ExecuteDelaySeconds")), stoppingToken);
            }
        }
    }
}
