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
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Risk.Common.Helpers;

namespace Risk.API.Services.Settings
{
    public class SettingsService : ISettingsService
    {
        private const double CACHE_EXPIRATION_MINUTES = 30;
        private readonly ILogger<SettingsService> _logger;
        private readonly IMemoryCache _cache;
        private readonly IConfiguration _configuration;
        private readonly IGenService _genService;

        public SettingsService(ILogger<SettingsService> logger, IMemoryCache cache, IConfiguration configuration, IGenService genService)
        {
            _logger = logger;
            _cache = cache;
            _configuration = configuration;
            _genService = genService;
        }

        public string GetDbConfigValue(string key)
        {
            var respuesta = _genService.ValorParametro(key);
            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                _logger.LogError($"Error al obtener valor de parámetro {key}: {respuesta}");
                return string.Empty;
            }

            return respuesta.Datos.Contenido;
        }

        public T GetFileConfigValue<T>(string key)
        {
            return _configuration.GetValue<T>(key);
        }

        // https://dev.to/bytehide/caching-in-net-full-guide-31j4
        public string GetCachedDbConfigValue(string key)
        {
            var cachedDataFound = _cache.TryGetValue<string>(key, out string cachedData);

            if (!cachedDataFound)
            {
                // Data not in cache, fetch and cache it
                cachedData = GetDbConfigValue(key);
                _cache.Set<string>(key, cachedData, DateTimeOffset.Now.AddMinutes(CACHE_EXPIRATION_MINUTES));
            }

            return cachedData;
        }

        public T GetCachedFileConfigValue<T>(string key)
        {
            var cachedDataFound = _cache.TryGetValue<T>(key, out T cachedData);

            if (!cachedDataFound)
            {
                // Data not in cache, fetch and cache it
                cachedData = GetFileConfigValue<T>(key);
                _cache.Set<T>(key, cachedData, DateTimeOffset.Now.AddMinutes(CACHE_EXPIRATION_MINUTES));
            }

            return cachedData;
        }

        #region Db Settings
        public bool EnableMailSender { get => GetCachedDbConfigValue("ENVIO_CORREOS_ACTIVO").Equals("S"); set => throw new NotImplementedException(); }
        public bool EnablePushSender { get => GetCachedDbConfigValue("ENVIO_NOTIFICACIONES_ACTIVO").Equals("S"); set => throw new NotImplementedException(); }
        public bool EnableSMSSender { get => GetCachedDbConfigValue("ENVIO_MENSAJES_ACTIVO").Equals("S"); set => throw new NotImplementedException(); }
        public string AccessTokenValidationKey { get => GetCachedDbConfigValue("CLAVE_VALIDACION_ACCESS_TOKEN"); set => throw new NotImplementedException(); }
        public string GoogleTokenIssuer { get => GetDbConfigValue("GOOGLE_EMISOR_TOKEN"); set => throw new NotImplementedException(); }
        public string GoogleTokenAudience { get => GetDbConfigValue("GOOGLE_IDENTIFICADOR_CLIENTE"); set => throw new NotImplementedException(); }
        #endregion

        #region File Settings
        // OracleConfiguration
        public string OracleConfigurationCharacterSet { get => GetFileConfigValue<string>("OracleConfiguration:CharacterSet"); set => throw new NotImplementedException(); }
        //
        public string JwtSigningKey { get => GetFileConfigValue<string>("JwtSigningKey"); set => throw new NotImplementedException(); }
        public bool EnableHttpStatusCodes { get => GetFileConfigValue<bool>("EnableHttpStatusCodes"); set => throw new NotImplementedException(); }
        // MsjConfiguration
        public double MsjConfigurationWorkerExecuteDelaySeconds { get => GetCachedFileConfigValue<double>("MsjConfiguration:WorkerExecuteDelaySeconds"); set => throw new System.NotImplementedException(); }
        // Gmail
        public string MsjConfigurationGmailMailboxFromName { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:MailboxFromName"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailMailboxFromAddress { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:MailboxFromAddress"); set => throw new NotImplementedException(); }
        public bool MsjConfigurationGmailEnableOAuth2 { get => GetFileConfigValue<bool>("MsjConfiguration:Gmail:EnableOAuth2"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailUserName { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:UserName"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailPassword { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:Password"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailUserId { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:UserId"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailClientId { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:ClientId"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailClientSecret { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:ClientSecret"); set => throw new NotImplementedException(); }
        public string MsjConfigurationGmailCredentialLocation { get => GetFileConfigValue<string>("MsjConfiguration:Gmail:CredentialLocation"); set => throw new NotImplementedException(); }
        // NotificationHub
        public string MsjConfigurationNotificationHubConnectionString { get => GetFileConfigValue<string>("MsjConfiguration:NotificationHub:ConnectionString"); set => throw new NotImplementedException(); }
        public string MsjConfigurationNotificationHubNotificationHubPath { get => GetFileConfigValue<string>("MsjConfiguration:NotificationHub:NotificationHubPath"); set => throw new NotImplementedException(); }
        // Twilio
        public string MsjConfigurationTwilioAccountSid { get => GetFileConfigValue<string>("MsjConfiguration:Twilio:AccountSid"); set => throw new NotImplementedException(); }
        public string MsjConfigurationTwilioAuthToken { get => GetFileConfigValue<string>("MsjConfiguration:Twilio:AuthToken"); set => throw new NotImplementedException(); }
        public string MsjConfigurationTwilioPhoneNumberFrom { get => GetFileConfigValue<string>("MsjConfiguration:Twilio:PhoneNumberFrom"); set => throw new NotImplementedException(); }
        #endregion
    }
}
