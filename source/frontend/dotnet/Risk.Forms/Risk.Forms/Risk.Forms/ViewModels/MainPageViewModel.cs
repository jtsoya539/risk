using Acr.UserDialogs;
using Prism.Commands;
using Prism.Navigation;
using Risk.API.Client.Api;
using Risk.API.Client.Model;
using System;
using Xamarin.Essentials.Interfaces;

namespace Risk.Forms.ViewModels
{
    public class MainPageViewModel : ViewModelBase
    {
        private readonly IAutApi _autApi;
        private readonly ISecureStorage _secureStorage;

        public MainPageViewModel(INavigationService navigationService, IAutApi autApi, ISecureStorage secureStorage)
            : base(navigationService)
        {
            Title = "Main Page";
            _autApi = autApi;
            _secureStorage = secureStorage;
        }

        private DelegateCommand finalizarSesionCommand;
        public DelegateCommand FinalizarSesionCommand =>
            finalizarSesionCommand ?? (finalizarSesionCommand = new DelegateCommand(ExecuteFinalizarSesionCommand, CanExecuteFinalizarSesionCommand));

        async void ExecuteFinalizarSesionCommand()
        {
            UserDialogs.Instance.ShowLoading("Cargando...");

            string accessToken;
            try
            {
                accessToken = await _secureStorage.GetAsync("ACCESS_TOKEN");
            }
            catch (Exception ex)
            {
                accessToken = string.Empty;
            }

            DatoRespuesta datoRespuesta = await _autApi.FinalizarSesionAsync(new FinalizarSesionRequestBody { AccessToken = accessToken });

            if (datoRespuesta.Codigo.Equals("0"))
            {
                _secureStorage.Remove("ACCESS_TOKEN");
                _secureStorage.Remove("REFRESH_TOKEN");

                App.IsUserLoggedIn = false;
                await NavigationService.NavigateAsync("/LoginPage");
            }

            UserDialogs.Instance.HideLoading();
        }

        bool CanExecuteFinalizarSesionCommand()
        {
            return true;
        }
    }
}
