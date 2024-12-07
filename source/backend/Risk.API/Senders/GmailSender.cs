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

using System.Threading;
using System.Threading.Tasks;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Util.Store;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Logging;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services.Settings;

namespace Risk.API.Senders
{
    public class GmailSender : RiskSenderBase, IMsjSender<Correo>
    {
        // Gmail Configuration
        private string mailboxFromName;
        private string mailboxFromAddress;
        private string userName;
        private string password;
        private SmtpClient smtpClient;
        private SaslMechanismOAuth2 oAuth2;

        public GmailSender(ILogger<GmailSender> logger, ISettingsService settingsService)
            : base(logger, settingsService)
        {
        }

        private async Task ConfigurarOAuth2Async()
        {
            var clientSecrets = new ClientSecrets
            {
                ClientId = _settingsService.MsjConfigurationGmailClientId,
                ClientSecret = _settingsService.MsjConfigurationGmailClientSecret
            };

            var codeFlow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
            {
                DataStore = new FileDataStore(_settingsService.MsjConfigurationGmailCredentialLocation, true),
                Scopes = new[] { "https://mail.google.com/" },
                ClientSecrets = clientSecrets
            });
            var codeReceiver = new LocalServerCodeReceiver();

            var authCode = new AuthorizationCodeInstalledApp(codeFlow, codeReceiver);
            var credential = await authCode.AuthorizeAsync(_settingsService.MsjConfigurationGmailUserId, CancellationToken.None);

            if (credential.Token.IsStale)
                await credential.RefreshTokenAsync(CancellationToken.None);

            oAuth2 = new SaslMechanismOAuth2(credential.UserId, credential.Token.AccessToken);
        }

        public async Task Configurar()
        {
            mailboxFromName = _settingsService.MsjConfigurationGmailMailboxFromName;
            mailboxFromAddress = _settingsService.MsjConfigurationGmailMailboxFromAddress;

            smtpClient = new SmtpClient();
            smtpClient.Connect("smtp.gmail.com", 465, SecureSocketOptions.SslOnConnect);

            if (_settingsService.MsjConfigurationGmailEnableOAuth2)
            {
                await ConfigurarOAuth2Async();
                await smtpClient.AuthenticateAsync(oAuth2);
            }
            else
            {
                userName = _settingsService.MsjConfigurationGmailUserName;
                password = _settingsService.MsjConfigurationGmailPassword;

                if (!string.IsNullOrEmpty(userName))
                {
                    await smtpClient.AuthenticateAsync(userName, password);
                }
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