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
using Risk.API.Helpers;
using Risk.API.Models;

namespace Risk.API.Workers
{
    public class MailWorker : BackgroundService
    {
        private readonly ILogger<MailWorker> _logger;
        private readonly IConfiguration _configuration;
        private readonly IMsjHelper _msjHelper;
        private readonly IMsjSender<Correo> _msjSender;

        public MailWorker(ILogger<MailWorker> logger, IConfiguration configuration, IMsjHelper msjHelper, IMsjSender<Correo> msjSender)
        {
            _logger = logger;
            _configuration = configuration;
            _msjHelper = msjHelper;
            _msjSender = msjSender;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                if (_msjHelper.EnvioCorreosActivo())
                {
                    _logger.LogInformation($"Ejecutando {this.GetType().Name}");

                    var mensajes = _msjHelper.ListarCorreosPendientes();

                    if (mensajes.Any())
                    {
                        await _msjSender.Configurar();

                        foreach (var item in mensajes)
                        {
                            try
                            {
                                await _msjSender.Enviar(item);

                                // Cambia estado de la mensajería a E-ENVIADO
                                _msjHelper.CambiarEstadoMensajeria(TipoMensajeria.Mail, item.IdCorreo, EstadoMensajeria.Enviado, "OK");
                            }
                            catch (Exception e)
                            {
                                // Cambia estado de la mensajería a R-PROCESADO CON ERROR
                                _msjHelper.CambiarEstadoMensajeria(TipoMensajeria.Mail, item.IdCorreo, EstadoMensajeria.ProcesadoError, e.Message);
                            }
                        }

                        await _msjSender.Desconfigurar();
                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(_configuration.GetValue<double>("MsjConfiguration:WorkerExecuteDelaySeconds")), stoppingToken);
            }
        }
    }
}
