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

namespace Risk.API.Services.Settings
{
    public interface ISettingsService
    {
        #region Db Settings
        bool EnableMailSender { get; set; }
        bool EnablePushSender { get; set; }
        bool EnableSMSSender { get; set; }
        string AccessTokenValidationKey { get; set; }
        string GoogleTokenIssuer { get; set; }
        string GoogleTokenAudience { get; set; }
        #endregion

        #region File Settings
        double MsjConfigurationWorkerExecuteDelaySeconds { get; set; }
        // Gmail
        string MsjConfigurationGmailMailboxFromName { get; set; }
        string MsjConfigurationGmailMailboxFromAddress { get; set; }
        bool MsjConfigurationGmailEnableOAuth2 { get; set; }
        string MsjConfigurationGmailUserName { get; set; }
        string MsjConfigurationGmailPassword { get; set; }
        string MsjConfigurationGmailUserId { get; set; }
        string MsjConfigurationGmailClientId { get; set; }
        string MsjConfigurationGmailClientSecret { get; set; }
        string MsjConfigurationGmailCredentialLocation { get; set; }
        // NotificationHub
        string MsjConfigurationNotificationHubConnectionString { get; set; }
        string MsjConfigurationNotificationHubNotificationHubPath { get; set; }
        // Twilio
        string MsjConfigurationTwilioAccountSid { get; set; }
        string MsjConfigurationTwilioAuthToken { get; set; }
        string MsjConfigurationTwilioPhoneNumberFrom { get; set; }
        #endregion
    }
}