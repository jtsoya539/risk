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
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Logging;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services.Settings;

namespace Risk.API.Senders
{
    public class SmtpSender : RiskSenderBase, IMsjSender<Correo>
    {
        // SMTP Configuration
        private string mailboxFromName;
        private string mailboxFromAddress;
        private string userName;
        private string password;
        private SmtpClient smtpClient;

        public SmtpSender(ILogger<SmtpSender> logger, ISettingsService settingsService)
            : base(logger, settingsService)
        {
        }

        public async Task Configurar()
        {
            mailboxFromName = _settingsService.MsjConfigurationGmailMailboxFromName;
            mailboxFromAddress = _settingsService.MsjConfigurationGmailMailboxFromAddress;

            smtpClient = new SmtpClient();
            smtpClient.Connect("mail.smtpbucket.com", 8025, SecureSocketOptions.Auto);

            userName = _settingsService.MsjConfigurationGmailUserName;
            password = _settingsService.MsjConfigurationGmailPassword;

            if (!string.IsNullOrEmpty(userName))
            {
                await smtpClient.AuthenticateAsync(userName, password);
            }
        }

        public async Task Desconfigurar()
        {
            await smtpClient.DisconnectAsync(true);
        }

        public async Task Enviar(Correo msj)
        {
            var message = MailHelper.GetMimeMessageFromCorreo(msj);
            await smtpClient.SendAsync(message);
        }
    }
}