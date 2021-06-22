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
using System.Threading.Tasks;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using Risk.API.Models;

namespace Risk.API.Senders
{
    public class NotificationHubSender : IMsjSender<Notificacion>
    {
        private readonly ILogger<NotificationHubSender> _logger;
        private readonly IConfiguration _configuration;

        // Notification Hub Configuration
        private NotificationHubClient hubClient;

        public NotificationHubSender(ILogger<NotificationHubSender> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        public Task Configurar()
        {
            hubClient = NotificationHubClient.CreateClientFromConnectionString(
                _configuration["MsjConfiguration:NotificationHub:ConnectionString"],
                _configuration["MsjConfiguration:NotificationHub:NotificationHubPath"]
            );
            return Task.CompletedTask;
        }

        public Task Desconfigurar()
        {
            return Task.CompletedTask;
        }

        public async Task Enviar(Notificacion msj)
        {
            var properties = new Dictionary<string, string> { { "titulo", msj.Titulo }, { "contenido", msj.Contenido } };
            if (msj.DatosExtra != null)
            {
                var datos = JObject.Parse(msj.DatosExtra);
                foreach (var x in datos)
                {
                    string name = x.Key;
                    string value = (string)x.Value;
                    properties.Add(name, value);
                }
            }
            await hubClient.SendTemplateNotificationAsync(properties, msj.Suscripcion);
        }
    }
}