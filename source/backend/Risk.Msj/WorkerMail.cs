using System;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Util;
using Google.Apis.Util.Store;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MimeKit;
using Risk.API.Client.Model;
using Risk.Msj.Helpers;

namespace Risk.Msj
{
    public class WorkerMail : BackgroundService
    {
        private readonly ILogger<WorkerMail> _logger;
        private readonly IConfiguration _configuration;

        // Risk Configuration
        private readonly IRiskAPIClientConnection _riskAPIClientConnection;

        // Mail Configuration
        private string mailboxFromName;
        private string mailboxFromAddress;
        private SmtpClient smtpClient;
        private SaslMechanismOAuth2 oAuth2;

        public WorkerMail(ILogger<WorkerMail> logger, IConfiguration configuration, IRiskAPIClientConnection riskAPIClientConnection)
        {
            _logger = logger;
            _configuration = configuration;

            // Risk Configuration
            _riskAPIClientConnection = riskAPIClientConnection;
        }

        // Mail Configuration
        private void Configurar()
        {
            mailboxFromName = _configuration["MailConfiguration:MailboxFromName"];
            mailboxFromAddress = _configuration["MailConfiguration:MailboxFromAddress"];

            smtpClient = new SmtpClient();
        }

        private async Task ConfigurarOAuth2Async()
        {
            var clientSecrets = new ClientSecrets
            {
                ClientId = _configuration["MailConfiguration:ClientId"],
                ClientSecret = _configuration["MailConfiguration:ClientSecret"]
            };

            var codeFlow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
            {
                DataStore = new FileDataStore(_configuration["MailConfiguration:CredentialLocation"], true),
                Scopes = new[] { "https://mail.google.com/" },
                ClientSecrets = clientSecrets
            });
            var codeReceiver = new LocalServerCodeReceiver();

            var authCode = new AuthorizationCodeInstalledApp(codeFlow, codeReceiver);
            var credential = await authCode.AuthorizeAsync(_configuration["MailConfiguration:UserId"], CancellationToken.None);

            if (credential.Token.IsExpired(SystemClock.Default))
                await credential.RefreshTokenAsync(CancellationToken.None);

            oAuth2 = new SaslMechanismOAuth2(credential.UserId, credential.Token.AccessToken);
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                if (_configuration.GetValue<bool>("EnableMail") && _riskAPIClientConnection.MensajeriaActiva)
                {
                    _logger.LogInformation($"WorkerMail running at: {DateTimeOffset.Now}");

                    var mensajes = _riskAPIClientConnection.ListarCorreosPendientes();

                    if (mensajes.Any())
                    {
                        // Mail Configuration
                        Configurar();
                        smtpClient.Connect("smtp.gmail.com", 465, SecureSocketOptions.SslOnConnect);

                        if (_configuration.GetValue<bool>("MailConfiguration:EnableOAuth2"))
                        {
                            await ConfigurarOAuth2Async();
                            smtpClient.Authenticate(oAuth2);
                        }
                        else
                        {
                            smtpClient.Authenticate(_configuration["MailConfiguration:UserName"], _configuration["MailConfiguration:Password"]);
                        }

                        foreach (var item in mensajes)
                        {
                            try
                            {
                                var message = new MimeMessage();
                                message.From.Add(new MailboxAddress(mailboxFromName, mailboxFromAddress));
                                message.To.Add(new MailboxAddress(item.MensajeTo, item.MensajeTo));

                                if (item.MensajeReplyTo != null)
                                {
                                    message.ReplyTo.Add(new MailboxAddress(item.MensajeReplyTo, item.MensajeReplyTo));
                                }

                                if (item.MensajeCc != null)
                                {
                                    message.Cc.Add(new MailboxAddress(item.MensajeCc, item.MensajeCc));
                                }

                                if (item.MensajeBcc != null)
                                {
                                    message.Bcc.Add(new MailboxAddress(item.MensajeBcc, item.MensajeBcc));
                                }

                                message.Subject = item.MensajeSubject;

                                var multipart = new Multipart("mixed");

                                // Body
                                string subtype;
                                if (item.MensajeBody.Contains("<html>") && item.MensajeBody.Contains("</html>"))
                                {
                                    subtype = "html";
                                }
                                else
                                {
                                    subtype = "plain";
                                }
                                var body = new TextPart(subtype)
                                {
                                    Text = item.MensajeBody
                                };
                                multipart.Add(body);

                                // Attachments
                                if (item.Adjuntos.Any())
                                {
                                    foreach (var adjunto in item.Adjuntos)
                                    {
                                        byte[] contenido = GZipHelper.Decompress(Convert.FromBase64String(adjunto.Contenido));
                                        using (var ms = new MemoryStream())
                                        {
                                            ms.Write(contenido, 0, contenido.Length);

                                            var attachment = new MimePart(adjunto.TipoMime)
                                            {
                                                Content = new MimeContent(ms, ContentEncoding.Default),
                                                ContentDisposition = new ContentDisposition(ContentDisposition.Attachment),
                                                ContentTransferEncoding = ContentEncoding.Base64,
                                                FileName = string.Concat(adjunto.Nombre, ".", adjunto.Extension)
                                            };
                                            multipart.Add(attachment);
                                        }
                                    }
                                }

                                message.Body = multipart;
                                smtpClient.Send(message);

                                // Cambia estado de la mensajería a E-ENVIADO
                                _riskAPIClientConnection.CambiarEstadoMensajeria(TipoMensajeria.Mail, item.IdCorreo, EstadoMensajeria.Enviado, "OK");
                            }
                            catch (Exception e)
                            {
                                // Cambia estado de la mensajería a R-PROCESADO CON ERROR
                                _riskAPIClientConnection.CambiarEstadoMensajeria(TipoMensajeria.Mail, item.IdCorreo, EstadoMensajeria.ProcesadoError, e.Message);
                            }
                        }

                        smtpClient.Disconnect(true);
                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(_configuration.GetValue<double>("ExecuteDelaySeconds")), stoppingToken);
            }
        }
    }
}
