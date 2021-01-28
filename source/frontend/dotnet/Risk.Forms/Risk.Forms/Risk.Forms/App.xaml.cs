using Prism;
using Prism.Ioc;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.Forms.ViewModels;
using Risk.Forms.Views;
using Xamarin.Essentials.Implementation;
using Xamarin.Essentials.Interfaces;
using Xamarin.Forms;

namespace Risk.Forms
{
    public partial class App
    {
        public static bool IsUserLoggedIn { get; set; }

        public App(IPlatformInitializer initializer)
            : base(initializer)
        {
        }

        protected override async void OnInitialized()
        {
            InitializeComponent();

            if (IsUserLoggedIn)
            {
                await NavigationService.NavigateAsync("/NavigationPage/MainPage");
            }
            else
            {
                await NavigationService.NavigateAsync("/LoginPage");
            }
        }

        protected override void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.RegisterSingleton<IAppInfo, AppInfoImplementation>();

            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");

            containerRegistry.RegisterInstance<IAutApi>(new AutApi(config));
            containerRegistry.RegisterInstance<IGenApi>(new GenApi(config));
            containerRegistry.RegisterInstance<IMsjApi>(new MsjApi(config));
            containerRegistry.RegisterInstance<IRepApi>(new RepApi(config));

            containerRegistry.RegisterForNavigation<NavigationPage>();
            containerRegistry.RegisterForNavigation<MainPage, MainPageViewModel>();
            containerRegistry.RegisterForNavigation<LoginPage, LoginPageViewModel>();
        }
    }
}
