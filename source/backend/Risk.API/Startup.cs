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
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;
using Oracle.ManagedDataAccess.Client;
using Risk.API.Filters;
using Risk.API.Helpers;
using Risk.API.Middlewares;
using Risk.API.Models;
using Risk.API.Senders;
using Risk.API.Services;
using Risk.API.Services.Settings;
using Risk.API.Workers;
using Risk.Common.Helpers;
using Swashbuckle.AspNetCore.SwaggerUI;

namespace Risk.API
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called when the application host is performing a graceful shutdown.
        private void OnShutdown()
        {
            OracleConnection.ClearAllPools();
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers().AddNewtonsoftJson(opt =>
            {
                opt.SerializerSettings.ContractResolver = new DefaultContractResolver
                {
                    NamingStrategy = null
                };
                opt.SerializerSettings.DateTimeZoneHandling = DateTimeZoneHandling.Utc;
                opt.SerializerSettings.Converters.Add(new StringEnumConverter());
            });

            services.AddCors(options =>
            {
                options.AddDefaultPolicy(builder =>
                {
                    builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
                });
            });

            services.AddHttpContextAccessor();

            services.AddMemoryCache();

            // Add Settings service
            services.AddSingleton<ISettingsService, SettingsService>();

            //services.AddDbContext<RiskDbContext>(options => options.UseOracle(oracleConnection));
            services.AddSingleton<IDbConnectionFactory, RiskDbConnectionFactory>();
            services.AddSingleton<INotificationHubClientConnection, NotificationHubClientConnection>();
            services.AddSingleton<IAutService, AutService>();
            services.AddSingleton<IGenService, GenService>();
            services.AddSingleton<IGloService, GloService>();
            services.AddSingleton<IMsjService, MsjService>();

            // Add Msj helper and senders
            services.AddSingleton<IMsjHelper, MsjHelper>();
            services.AddSingleton<IMsjSender<Correo>, SmtpSender>();
            services.AddSingleton<IMsjSender<Notificacion>, NotificationHubSender>();
            services.AddSingleton<IMsjSender<Mensaje>, TwilioSender>();

            // Add Msj workers
            if (Configuration.GetValue<bool>("MsjConfiguration:EnableMailWorker"))
                services.AddHostedService<MailWorker>();
            if (Configuration.GetValue<bool>("MsjConfiguration:EnablePushWorker"))
                services.AddHostedService<PushWorker>();
            if (Configuration.GetValue<bool>("MsjConfiguration:EnableSMSWorker"))
                services.AddHostedService<SMSWorker>();

            services.AddSingleton<TokenHandler, RiskTokenHandler>();
            services.AddSingleton<IPostConfigureOptions<JwtBearerOptions>, RiskJwtBearerPostConfigureOptions>();

            //var signingKey = Encoding.ASCII.GetBytes(Configuration["JwtSigningKey"]);

            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(x =>
            {
                x.RequireHttpsMetadata = false;
                x.SaveToken = true;
                x.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ValidateIssuerSigningKey = true,
                    //IssuerSigningKey = new SymmetricSecurityKey(signingKey),
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(10)
                    //ClockSkew = TimeSpan.Zero
                };
            });

            // Register the Swagger generator, defining 1 or more Swagger documents
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc(Configuration["SwaggerConfiguration:Version"], new OpenApiInfo
                {
                    Title = Configuration["SwaggerConfiguration:Title"],
                    Description = Configuration["SwaggerConfiguration:Description"],
                    Version = Configuration["SwaggerConfiguration:Version"],
                    Contact = new OpenApiContact
                    {
                        Name = Configuration["SwaggerConfiguration:Contact:Name"],
                        Url = new Uri(Configuration["SwaggerConfiguration:Contact:Url"]),
                        Email = Configuration["SwaggerConfiguration:Contact:Email"]
                    },
                    License = new OpenApiLicense
                    {
                        Name = Configuration["SwaggerConfiguration:License:Name"],
                        Url = new Uri(Configuration["SwaggerConfiguration:License:Url"])
                    }
                });
                c.AddSecurityDefinition(RiskConstants.SECURITY_SCHEME_RISK_APP_KEY, new OpenApiSecurityScheme
                {
                    Description = "Clave de la aplicación habilitada para consumir servicios",
                    Type = SecuritySchemeType.ApiKey,
                    In = ParameterLocation.Header,
                    Name = RiskConstants.HEADER_RISK_APP_KEY
                });
                c.AddSecurityDefinition(RiskConstants.SECURITY_SCHEME_ACCESS_TOKEN, new OpenApiSecurityScheme
                {
                    Description = "Access Token de la sesión (Token Bearer en formato JWT)",
                    Type = SecuritySchemeType.Http,
                    In = ParameterLocation.Header,
                    Name = RiskConstants.HEADER_AUTHORIZATION,
                    Scheme = "bearer", // JwtBearerDefaults.AuthenticationScheme
                    BearerFormat = "JWT"
                });
                c.EnableAnnotations();
                c.DocumentFilter<ServersDocumentFilter>();
                c.OperationFilter<SecurityRequirementsOperationFilter>();
                c.OperationFilter<ServiceErrorsOperationFilter>();
                c.OperationFilter<HeaderParameterOperationFilter>(RiskConstants.HEADER_RISK_DEVICE_TOKEN, "Token del dispositivo desde el cual se realiza la petición", false);
                c.OperationFilter<HeaderParameterOperationFilter>(RiskConstants.HEADER_RISK_SERVICE_VERSION, "Versión del servicio", false);
                //c.SchemaFilter<NotNullableSchemaFilter>();
            });
            services.AddSwaggerGenNewtonsoftSupport();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IHostApplicationLifetime appLifetime)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseRiskExceptionHandler();

                app.UseHttpsRedirection();
            }

            app.UseStaticFiles();

            // Enable middleware to serve generated Swagger as a JSON endpoint.
            app.UseSwagger();

            // Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.), specifying the Swagger JSON endpoint.
            app.UseSwaggerUI(c =>
            {
                c.DocumentTitle = Configuration["SwaggerConfiguration:Title"];
                c.RoutePrefix = string.Empty;
                c.SwaggerEndpoint($"/swagger/{Configuration["SwaggerConfiguration:Version"]}/swagger.json",
                                  $"{Configuration["SwaggerConfiguration:Title"]} {Configuration["SwaggerConfiguration:Version"]}");
                c.DocExpansion(DocExpansion.None);
                c.InjectStylesheet("/css/swagger-ui.css");
            });

            app.UseRouting();

            app.UseCors();

            app.UseRiskApplicationKeyValidator();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            appLifetime.ApplicationStopping.Register(OnShutdown);
        }
    }
}
