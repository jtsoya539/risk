using Acr.UserDialogs;
using Polly;
using Polly.Registry;
using Prism;
using Prism.DryIoc;
using Prism.Ioc;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;
using Risk.Common.Helpers;
using Risk.Forms.ViewModels;
using Risk.Forms.Views;
using System;
using Xamarin.Essentials;
using Xamarin.Essentials.Implementation;
using Xamarin.Essentials.Interfaces;
using Xamarin.Forms;

namespace Risk.Forms
{
    public partial class App : PrismApplication
    {
        public App(IPlatformInitializer initializer) : base(initializer)
        {
        }

        protected override async void OnInitialized()
        {
            InitializeComponent();

            if (!this.Properties.ContainsKey(RiskConstants.IS_USER_LOGGED_IN))
                this.Properties[RiskConstants.IS_USER_LOGGED_IN] = false;

            if (!this.Properties.ContainsKey(RiskConstants.IS_CONNECTED))
                this.Properties[RiskConstants.IS_CONNECTED] = false;

            var autApi = Container.Resolve<IAutApi>();
            var genApi = Container.Resolve<IGenApi>();
            var appInfo = Container.Resolve<IAppInfo>();
            var deviceInfo = Container.Resolve<IDeviceInfo>();
            var secureStorage = Container.Resolve<ISecureStorage>();
            var connectivity = Container.Resolve<IConnectivity>();

            // Registra evento ConnectivityChanged
            connectivity.ConnectivityChanged += Connectivity_ConnectivityChanged;

            // Valida conexión a Internet
            if (connectivity.NetworkAccess != NetworkAccess.Internet)
            {
                this.Properties[RiskConstants.IS_CONNECTED] = false;
                await NavigationService.NavigateAsync("/NoConnectionPage");
                return;
            }

            AplicacionPaginaRespuesta respuestaListarAplicaciones = null;
            try
            {
                respuestaListarAplicaciones = genApi.ListarAplicaciones(null, "azVd94zazPu/+q5ZHqoL1v6wccamHV3oWoALYWQK0Z8=");
            }
            catch (Exception)
            {
                await UserDialogs.Instance.AlertAsync("La aplicación no está activa");
            }

            if (respuestaListarAplicaciones.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                var aplicacion = respuestaListarAplicaciones.Datos.Elementos[0];

                // Valida si la aplicación está activa
                if (!aplicacion.Activo)
                {
                    await UserDialogs.Instance.AlertAsync("La aplicación no está activa");
                }

                // Valida versión de la aplicación
                Version versionAplicacion = new Version(appInfo.VersionString);
                Version versionServidor = new Version(aplicacion.VersionActual);

                switch (versionAplicacion.CompareTo(versionServidor))
                {
                    case 0:
                        //Console.Write("the same as");
                        break;
                    case 1:
                        //Console.Write("later than");
                        break;
                    case -1:
                        //Console.Write("earlier than");
                        await UserDialogs.Instance.AlertAsync("Es necesaria una actualización de la aplicación");
                        break;
                }
            }

            // Registra dispositivo
            string deviceToken;
            try
            {
                deviceToken = await secureStorage.GetAsync(RiskConstants.DEVICE_TOKEN);
            }
            catch (Exception ex)
            {
                deviceToken = string.Empty;
            }

            DatoRespuesta datoRespuesta = autApi.RegistrarDispositivo(null, new RegistrarDispositivoRequestBody
            {
                Dispositivo = new Dispositivo
                {
                    IdDispositivo = 0,
                    TokenDispositivo = deviceToken,
                    NombreSistemaOperativo = deviceInfo.Platform.ToString(),
                    VersionSistemaOperativo = deviceInfo.VersionString,
                    Tipo = TipoDispositivo.Mobile
                }
            });

            if (datoRespuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                await secureStorage.SetAsync(RiskConstants.DEVICE_TOKEN, datoRespuesta.Datos.Contenido);
            }

            if ((bool)this.Properties[RiskConstants.IS_USER_LOGGED_IN])
            {
                await NavigationService.NavigateAsync("/NavigationPage/MainPage");
            }
            else
            {
                await NavigationService.NavigateAsync("/LoginPage");
            }
        }

        private void Connectivity_ConnectivityChanged(object sender, ConnectivityChangedEventArgs e)
        {
            var connectivity = Container.Resolve<IConnectivity>();

            if (connectivity.NetworkAccess != NetworkAccess.Internet)
            {
                _ = NavigationService.NavigateAsync("/NoConnectionPage");
                return;
            }

            if ((bool)this.Properties[RiskConstants.IS_USER_LOGGED_IN])
            {
                _ = NavigationService.NavigateAsync("/NavigationPage/MainPage");
            }
            else
            {
                _ = NavigationService.NavigateAsync("/LoginPage");
            }
        }

        protected override void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.RegisterSingleton<IAppInfo, AppInfoImplementation>();
            containerRegistry.RegisterSingleton<IDeviceInfo, DeviceInfoImplementation>();
            containerRegistry.RegisterSingleton<ISecureStorage, SecureStorageImplementation>();
            containerRegistry.RegisterSingleton<IConnectivity, ConnectivityImplementation>();

            Configuration config = new Configuration();
            config.BasePath = "http://10.0.2.2:5000";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "azVd94zazPu/+q5ZHqoL1v6wccamHV3oWoALYWQK0Z8=");
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = string.Empty;

            containerRegistry.RegisterInstance<IReadableConfiguration>(config);
            containerRegistry.RegisterInstance<IAutApi>(new AutApi(config));
            containerRegistry.RegisterInstance<IGenApi>(new GenApi(config));
            containerRegistry.RegisterInstance<IMsjApi>(new MsjApi(config));
            containerRegistry.RegisterInstance<IRepApi>(new RepApi(config));

            containerRegistry.RegisterForNavigation<NavigationPage>();
            containerRegistry.RegisterForNavigation<MainPage, MainPageViewModel>();
            containerRegistry.RegisterForNavigation<LoginPage, LoginPageViewModel>();
            containerRegistry.RegisterForNavigation<NoConnectionPage, NoConnectionPageViewModel>();

            // Polly
            PolicyRegistry registry = new PolicyRegistry();
            var authorizationEnsuringPolicy = Policy
                .HandleResult<ApiException>(r => r.ErrorCode == 401 /*HttpStatusCode.Unauthorized*/)
                .RetryAsync(1, async (outcome, retryNumber, context) =>
                    {
                        var autApi = Container.Resolve<IAutApi>();
                        var secureStorage = Container.Resolve<ISecureStorage>();

                        // Busca Access Token
                        string accessToken;
                        try
                        {
                            accessToken = await secureStorage.GetAsync(RiskConstants.ACCESS_TOKEN);
                        }
                        catch (Exception)
                        {
                            accessToken = string.Empty;
                        }

                        // Busca Refresh Token
                        string refreshToken;
                        try
                        {
                            refreshToken = await secureStorage.GetAsync(RiskConstants.REFRESH_TOKEN);
                        }
                        catch (Exception)
                        {
                            refreshToken = string.Empty;
                        }

                        SesionRespuesta respuestaRefrescarSesion = null;
                        try
                        {
                            respuestaRefrescarSesion = await autApi.RefrescarSesionAsync(null, new RefrescarSesionRequestBody
                            {
                                AccessToken = accessToken,
                                RefreshToken = refreshToken
                            });

                            if (respuestaRefrescarSesion.Codigo.Equals(RiskConstants.CODIGO_OK))
                            {
                                await secureStorage.SetAsync(RiskConstants.ACCESS_TOKEN, respuestaRefrescarSesion.Datos.AccessToken);
                                await secureStorage.SetAsync(RiskConstants.REFRESH_TOKEN, respuestaRefrescarSesion.Datos.RefreshToken);

                                var apiConfig = (Configuration)autApi.Configuration; // Aca en realidad hay que configurar todos los Api?
                                config.AccessToken = respuestaRefrescarSesion.Datos.AccessToken;

                                this.Properties[RiskConstants.IS_USER_LOGGED_IN] = true;
                            }
                            else
                            {
                                secureStorage.Remove(RiskConstants.ACCESS_TOKEN);
                                secureStorage.Remove(RiskConstants.REFRESH_TOKEN);

                                this.Properties[RiskConstants.IS_USER_LOGGED_IN] = false;
                                await NavigationService.NavigateAsync("/LoginPage");
                            }
                        }
                        catch (Exception)
                        {
                            secureStorage.Remove(RiskConstants.ACCESS_TOKEN);
                            secureStorage.Remove(RiskConstants.REFRESH_TOKEN);

                            this.Properties[RiskConstants.IS_USER_LOGGED_IN] = false;
                            await NavigationService.NavigateAsync("/LoginPage");
                        }
                    }
                );

            registry.Add("AuthorizationEnsuringPolicy", authorizationEnsuringPolicy);
        }

        protected override void OnSleep()
        {
            base.OnSleep();
        }

        protected override void OnResume()
        {
            base.OnResume();
        }
    }
}
