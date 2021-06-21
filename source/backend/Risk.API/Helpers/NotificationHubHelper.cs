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
using Microsoft.Azure.NotificationHubs;
using Risk.API.Models;
using Risk.API.Services;

namespace Risk.API.Helpers
{
    public static class NotificationHubHelper
    {
        public static void RegistrarDispositivo(string tokenDispositivo, IAutService autService, INotificationHubClientConnection notificationHubClientConnection)
        {
            if (notificationHubClientConnection.Hub == null)
            {
                return;
            }

            var respDatosDispositivo = autService.DatosDispositivo(tokenDispositivo);
            if (!respDatosDispositivo.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return;
            }

            Dispositivo dispositivo = respDatosDispositivo.Datos;

            if (dispositivo.TokenNotificacion == null || dispositivo.TokenNotificacion.Equals(string.Empty))
            {
                return;
            }

            NotificationPlatform platform;
            switch (dispositivo.PlataformaNotificacion)
            {
                case "wns":
                    platform = NotificationPlatform.Wns;
                    break;
                case "apns":
                    platform = NotificationPlatform.Apns;
                    break;
                case "mpns":
                    platform = NotificationPlatform.Mpns;
                    break;
                case "fcm":
                    platform = NotificationPlatform.Fcm;
                    break;
                case "adm":
                    platform = NotificationPlatform.Adm;
                    break;
                case "baidu":
                    platform = NotificationPlatform.Baidu;
                    break;
                default:
                    platform = NotificationPlatform.Fcm;
                    break;
            }

            List<string> tags = new List<string>();
            if (dispositivo.Suscripciones != null)
            {
                foreach (var item in dispositivo.Suscripciones)
                {
                    tags.Add(item.Contenido);
                }
            }

            var templates = new Dictionary<string, InstallationTemplate>()
            {
                {dispositivo.Plantillas[0].Nombre, new InstallationTemplate { Body = dispositivo.Plantillas[0].Contenido }}
            };

            Installation installation = new Installation
            {
                InstallationId = dispositivo.TokenDispositivo,
                Platform = platform,
                PushChannel = dispositivo.TokenNotificacion,
                PushChannelExpired = false,
                Tags = tags,
                Templates = templates
            };

            notificationHubClientConnection.Hub.CreateOrUpdateInstallation(installation);
        }
    }
}