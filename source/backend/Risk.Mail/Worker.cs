using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Util.Store;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MimeKit;
using Newtonsoft.Json;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Risk.Mail
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

        // Mail Configuration
        private readonly SmtpClient _smtpClient;
        private readonly string _mailboxFromName;
        private readonly string _mailboxFromAddress;
        private SaslMechanismOAuth2 oAuth2;

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

            // Mail Configuration
            _mailboxFromName = _configuration["MailConfiguration:MailboxFromName"];
            _mailboxFromAddress = _configuration["MailConfiguration:MailboxFromAddress"];

            _smtpClient = new SmtpClient();
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

        private List<Correo> ListarCorreosPendientes()
        {
            List<Correo> mensajes = new List<Correo>();

            CorreoPaginaRespuesta mensajesPendientes = null;
            try
            {
                mensajesPendientes = msjApi.ListarCorreosPendientes(null, null, "S");
            }
            catch (ApiException e)
            {
                if (e.ErrorCode == 401)
                {
                    RefrescarSesion();

                    try
                    {
                        mensajesPendientes = msjApi.ListarCorreosPendientes(null, null, "S");
                    }
                    catch (ApiException ex)
                    {
                        _logger.LogError($"Error al obtener lista de correos pendientes: {ex.Message}");
                    }
                }
            }

            if (mensajesPendientes != null && mensajesPendientes.Codigo.Equals("0") && mensajesPendientes.Datos.CantidadElementos > 0)
            {
                mensajes = mensajesPendientes.Datos.Elementos;
            }

            return mensajes;
        }

        private void CambiarEstadoMensajeria(int idMensajeria, EstadoMensajeria estado, string respuestaEnvio)
        {
            DatoRespuesta datoRespuesta = new DatoRespuesta();
            try
            {
                datoRespuesta = msjApi.CambiarEstadoMensajeria(new CambiarEstadoMensajeriaRequestBody
                {
                    TipoMensajeria = TipoMensajeria.Mail,
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
                            TipoMensajeria = TipoMensajeria.Mail,
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

            if (authCode.ShouldRequestAuthorizationCode(credential.Token))
                await credential.RefreshTokenAsync(CancellationToken.None);

            oAuth2 = new SaslMechanismOAuth2(credential.UserId, credential.Token.AccessToken);
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation($"Worker running at: {DateTimeOffset.Now}");

                var mensajes = ListarCorreosPendientes();

                if (mensajes.Any())
                {
                    await ConfigurarOAuth2Async();

                    _smtpClient.Connect("smtp.gmail.com", 465, SecureSocketOptions.SslOnConnect);
                    _smtpClient.Authenticate(oAuth2);
                    // _smtpClient.Authenticate(_configuration["MailConfiguration:Usuario"], _configuration["MailConfiguration:Clave"]);

                    foreach (var item in mensajes)
                    {
                        try
                        {
                            var message = new MimeMessage();
                            message.From.Add(new MailboxAddress(_mailboxFromName, _mailboxFromAddress));
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
                            message.Body = new TextPart("plain")
                            {
                                Text = item.MensajeBody
                            };

                            _smtpClient.Send(message);

                            // Cambia estado de la mensajería a E-ENVIADO
                            CambiarEstadoMensajeria(item.IdCorreo, EstadoMensajeria.Enviado, "OK");
                        }
                        catch (Exception e)
                        {
                            // Cambia estado de la mensajería a R-PROCESADO CON ERROR
                            CambiarEstadoMensajeria(item.IdCorreo, EstadoMensajeria.ProcesadoError, e.Message);
                        }
                    }

                    _smtpClient.Disconnect(true);
                }

                await Task.Delay(TimeSpan.FromSeconds(_configuration.GetValue<double>("ExecuteDelaySeconds")), stoppingToken);
            }
        }
    }
}
