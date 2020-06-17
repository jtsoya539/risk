using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace Risk.SMS
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IConfiguration _configuration;
        private readonly IAutApi _autApi;
        private string accountSid;
        private string authToken;
        private string phoneNumberFrom;
        private string AccessToken;
        private string RefreshToken;

        public Worker(ILogger<Worker> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;

            Configuration config = new Configuration();
            config.BasePath = _configuration["RiskConfiguration:RiskAPIBasePath"];
            _autApi = new AutApi(config);

            accountSid = _configuration["TwilioConfiguration:AccountSid"];
            authToken = _configuration["TwilioConfiguration:AuthToken"];
            phoneNumberFrom = _configuration["TwilioConfiguration:PhoneNumberFrom"];
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation($"Worker running at: {DateTimeOffset.Now}");

                TwilioClient.Init(accountSid, authToken);

                var message = MessageResource.Create(
                    body: $"Message sending at: {DateTimeOffset.Now}",
                    from: new Twilio.Types.PhoneNumber(phoneNumberFrom),
                    to: new Twilio.Types.PhoneNumber("+595991384113")
                );

                _logger.LogInformation(message.Sid);

                await Task.Delay(10000, stoppingToken);
            }
        }
    }
}
