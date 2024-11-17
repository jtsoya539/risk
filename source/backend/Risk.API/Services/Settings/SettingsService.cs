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

        // https://dev.to/bytehide/caching-in-net-full-guide-31j4
        public string GetDbConfigValue(string key)
        {
            var cachedDataFound = _cache.TryGetValue<string>(key, out string cachedData);

            if (!cachedDataFound)
            {
                // Data not in cache, fetch and cache it
                var respuesta = _genService.ValorParametro(key);
                if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
                {
                    _logger.LogError($"Error al obtener valor de parámetro {key}: {respuesta}");
                    return string.Empty;
                }
                cachedData = respuesta.Datos.Contenido;
                _cache.Set<string>(key, cachedData, DateTimeOffset.Now.AddMinutes(CACHE_EXPIRATION_MINUTES));
            }

            return cachedData;
        }

        public T GetFileConfigValue<T>(string key)
        {
            var cachedDataFound = _cache.TryGetValue<T>(key, out T cachedData);

            if (!cachedDataFound)
            {
                // Data not in cache, fetch and cache it
                cachedData = _configuration.GetValue<T>(key);
                _cache.Set<T>(key, cachedData, DateTimeOffset.Now.AddMinutes(CACHE_EXPIRATION_MINUTES));
            }

            return cachedData;
        }

        public bool EnableMailSender { get => GetDbConfigValue("ENVIO_CORREOS_ACTIVO").Equals("S"); set => throw new NotImplementedException(); }
        public bool EnablePushSender { get => GetDbConfigValue("ENVIO_NOTIFICACIONES_ACTIVO").Equals("S"); set => throw new NotImplementedException(); }
        public bool EnableSMSSender { get => GetDbConfigValue("ENVIO_MENSAJES_ACTIVO").Equals("S"); set => throw new NotImplementedException(); }
        public string AccessTokenValidationKey { get => GetDbConfigValue("CLAVE_VALIDACION_ACCESS_TOKEN"); set => throw new NotImplementedException(); }
        public double MsjConfigurationWorkerExecuteDelaySeconds { get => GetFileConfigValue<double>("MsjConfiguration:WorkerExecuteDelaySeconds"); set => throw new System.NotImplementedException(); }
    }
}
