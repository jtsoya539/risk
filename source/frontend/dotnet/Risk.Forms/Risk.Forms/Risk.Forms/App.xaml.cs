using Acr.UserDialogs;
using Prism;
using Prism.DryIoc;
using Prism.Ioc;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;
using Risk.Forms.Helpers;
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

            Properties[RiskConstants.IS_USER_LOGGED_IN] = false;
            Properties[RiskConstants.IS_CONNECTED] = false;

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

            if (respuestaListarAplicaciones.Codigo.Equals("0"))
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

            if (datoRespuesta.Codigo.Equals("0"))
            {
                await secureStorage.SetAsync(RiskConstants.DEVICE_TOKEN, datoRespuesta.Datos.Contenido);
            }

            if ((bool)Properties[RiskConstants.IS_USER_LOGGED_IN])
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

            if ((bool)Properties[RiskConstants.IS_USER_LOGGED_IN])
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
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = string.Empty;
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "azVd94zazPu/+q5ZHqoL1v6wccamHV3oWoALYWQK0Z8=");

            containerRegistry.RegisterInstance<IReadableConfiguration>(config);
            containerRegistry.RegisterInstance<IAutApi>(new AutApi(config));
            containerRegistry.RegisterInstance<IGenApi>(new GenApi(config));
            containerRegistry.RegisterInstance<IMsjApi>(new MsjApi(config));
            containerRegistry.RegisterInstance<IRepApi>(new RepApi(config));

            containerRegistry.RegisterForNavigation<NavigationPage>();
            containerRegistry.RegisterForNavigation<MainPage, MainPageViewModel>();
            containerRegistry.RegisterForNavigation<LoginPage, LoginPageViewModel>();
            containerRegistry.RegisterForNavigation<NoConnectionPage, NoConnectionPageViewModel>();
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
