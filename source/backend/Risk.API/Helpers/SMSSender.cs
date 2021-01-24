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

using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Risk.API.Models;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace Risk.API.Helpers
{
    public class SMSSender : IMsjSender<Mensaje>
    {
        private readonly ILogger<SMSSender> _logger;
        private readonly IConfiguration _configuration;

        // Twilio Configuration
        private string phoneNumberFrom;

        public SMSSender(ILogger<SMSSender> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        public Task Configurar()
        {
            TwilioClient.Init(_configuration["TwilioConfiguration:AccountSid"], _configuration["TwilioConfiguration:AuthToken"]);
            phoneNumberFrom = _configuration["TwilioConfiguration:PhoneNumberFrom"];
            return Task.CompletedTask;
        }

        public Task Desconfigurar()
        {
            return Task.CompletedTask;
        }

        public async Task Enviar(Mensaje msj)
        {
            var message = await MessageResource.CreateAsync(
                from: new PhoneNumber(phoneNumberFrom),
                to: new PhoneNumber(msj.NumeroTelefono),
                body: msj.Contenido
            );
        }
    }
}