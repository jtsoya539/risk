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

using Microsoft.Azure.NotificationHubs;
using Risk.API.Services.Settings;

namespace Risk.API.Helpers
{
    public class NotificationHubClientConnection : INotificationHubClientConnection
    {
        private readonly ISettingsService _settingsService;
        public NotificationHubClient Hub { get; set; }

        public NotificationHubClientConnection(ISettingsService settingsService)
        {
            _settingsService = settingsService;
            string connectionString = _settingsService.MsjConfigurationNotificationHubConnectionString;
            string notificationHubPath = _settingsService.MsjConfigurationNotificationHubNotificationHubPath;
            if (!connectionString.Equals(string.Empty) && !notificationHubPath.Equals(string.Empty))
            {
                Hub = NotificationHubClient.CreateClientFromConnectionString(connectionString, notificationHubPath);
            }
        }
    }
}