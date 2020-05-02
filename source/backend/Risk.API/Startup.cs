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
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Oracle.ManagedDataAccess.Client;
using Risk.API.Entities;
using Risk.API.Filters;
using Risk.API.Middlewares;
using Risk.API.Services;
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

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);

            services.AddCors();

            string oracleLocation = Configuration["OracleConfiguration:OracleLocation"];
            if (!Directory.Exists(oracleLocation))
            {
                throw new Exception($"El directorio {oracleLocation} no existe");
            }

            //Enter directory where the tnsnames.ora and sqlnet.ora files are located
            OracleConfiguration.TnsAdmin = oracleLocation;

            //Enter directory where wallet is stored locally
            OracleConfiguration.WalletLocation = $"(SOURCE = (METHOD = file) (METHOD_DATA = (DIRECTORY=\"{oracleLocation}\")))";

            string connectionString = Configuration.GetConnectionString(Configuration.GetValue<string>("Database"));
            OracleConnectionStringBuilder connStrBuilder = new OracleConnectionStringBuilder(connectionString);

            // Connection Pooling Configuration
            connStrBuilder.Pooling = true; // Connection pooling.
            connStrBuilder.MinPoolSize = 5; // Minimum number of connections in a pool.
            connStrBuilder.MaxPoolSize = 5; // Maximum number of connections in a pool.
            //connStrBuilder.ConnectionLifeTime = 300; // Maximum life time (in seconds) of the connection.
            //connStrBuilder.ConnectionTimeout = 30; // Maximum time (in seconds) to wait for a free connection from the pool.

            OracleConnection con = new OracleConnection(connStrBuilder.ToString());
            OracleConnection.ClearAllPools();

            services.AddDbContext<RiskDbContext>(options => options.UseOracle(con));
            services.AddScoped<IGenService, GenService>();
            services.AddScoped<IAutService, AutService>();

            var serviceProvider = services.BuildServiceProvider();
            IGenService genService = serviceProvider.GetService<IGenService>();
            IAutService autService = serviceProvider.GetService<IAutService>();

            //var respValorParametro = genService.ValorParametro("CLAVE_VALIDACION_ACCESS_TOKEN");
            //var signingKey = Encoding.ASCII.GetBytes(respValorParametro.Datos.Contenido);
            var signingKey = Encoding.ASCII.GetBytes("9vVzzZbbUCcYE3cDnE+IVMrLF+8X8TPyK2cmC3Vu7M0=");

            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(x =>
            {
                x.SecurityTokenValidators.Clear();
                x.SecurityTokenValidators.Add(new RiskSecurityTokenValidator(autService));
                x.RequireHttpsMetadata = false;
                x.SaveToken = true;
                x.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(signingKey),
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(10)
                    // ClockSkew = TimeSpan.Zero
                };
            });

            // Register the Swagger generator, defining 1 or more Swagger documents
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "Risk.API",
                    Description = "Risk Web API",
                    Version = "v1",
                    Contact = new OpenApiContact
                    {
                        Name = "jtsoya539",
                        Url = new Uri("https://github.com/jtsoya539"),
                        Email = "javier.meza.py@gmail.com"
                    },
                    License = new OpenApiLicense
                    {
                        Name = "MIT",
                        Url = new Uri("https://github.com/jtsoya539/risk/blob/master/LICENSE")
                    }
                });
                c.EnableAnnotations();
                c.AddSecurityDefinition("AccessToken", new OpenApiSecurityScheme
                {
                    Type = SecuritySchemeType.ApiKey, //SecuritySchemeType.Http
                    Name = "Authorization",
                    Description = "JWT Authorization header using the Bearer scheme. Example: \"Bearer {token}\"",
                    In = ParameterLocation.Header,
                    Scheme = JwtBearerDefaults.AuthenticationScheme,
                    BearerFormat = "xxxxx.yyyyy.zzzzz"
                });
                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference { Type =  ReferenceType.SecurityScheme, Id = "AccessToken" }
                        },
                        new string[] { }
                    }
                });
                c.DocumentFilter<RiskDocumentFilter>();
                c.OperationFilter<RiskApplicationKeyHeaderOperationFilter>();
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseStaticFiles();

            // Enable middleware to serve generated Swagger as a JSON endpoint.
            app.UseSwagger();

            // Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.),
            // specifying the Swagger JSON endpoint.
            app.UseSwaggerUI(c =>
            {
                c.DocumentTitle = "Risk.API";
                c.RoutePrefix = string.Empty;
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Risk.API v1");
                c.DocExpansion(DocExpansion.None);
                c.InjectStylesheet("/swagger-ui/custom.css");
            });

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRiskApplicationKeyValidator();

            app.UseAuthentication();

            app.UseCors(builder =>
               builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader().AllowCredentials()
            );

            app.UseMvc();
        }
    }
}
