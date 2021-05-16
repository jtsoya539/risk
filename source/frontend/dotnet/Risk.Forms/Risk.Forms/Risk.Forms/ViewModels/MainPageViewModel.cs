using Acr.UserDialogs;
using Prism.Commands;
using Prism.Navigation;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;
using Risk.Forms.Helpers;
using Risk.Forms.Resources.Resx;
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
            UserDialogs.Instance.ShowLoading(AppResources.ShowLoadingTitle);

            string accessToken;
            try
            {
                accessToken = await _secureStorage.GetAsync(RiskConstants.ACCESS_TOKEN);
            }
            catch (Exception ex)
            {
                accessToken = string.Empty;
            }

            DatoRespuesta respuestaFinalizarSesion = null;
            try
            {
                respuestaFinalizarSesion = await _autApi.FinalizarSesionAsync(null, new FinalizarSesionRequestBody { AccessToken = accessToken });

                if (respuestaFinalizarSesion.Codigo.Equals(RiskConstants.CODIGO_OK))
                {
                    _secureStorage.Remove(RiskConstants.ACCESS_TOKEN);
                    _secureStorage.Remove(RiskConstants.REFRESH_TOKEN);

                    App.Current.Properties[RiskConstants.IS_USER_LOGGED_IN] = false;
                    await NavigationService.NavigateAsync("/LoginPage");
                }
                else
                {
                    await UserDialogs.Instance.AlertAsync("Error al finalizar sesión");
                }
            }
            catch (ApiException ex)
            {
                if (ex.ErrorCode.Equals(401))
                {
                    _secureStorage.Remove(RiskConstants.ACCESS_TOKEN);
                    _secureStorage.Remove(RiskConstants.REFRESH_TOKEN);

                    App.Current.Properties[RiskConstants.IS_USER_LOGGED_IN] = false;
                    await NavigationService.NavigateAsync("/LoginPage");
                }
                else
                {
                    await UserDialogs.Instance.AlertAsync("Error al finalizar sesión");
                }
            }
            catch (Exception ex)
            {
                await UserDialogs.Instance.AlertAsync("Error al finalizar sesión");
            }

            UserDialogs.Instance.HideLoading();
        }

        bool CanExecuteFinalizarSesionCommand()
        {
            return true;
        }
    }
}
