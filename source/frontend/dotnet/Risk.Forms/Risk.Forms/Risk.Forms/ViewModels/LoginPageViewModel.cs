using Acr.UserDialogs;
using Prism.Commands;
using Prism.Navigation;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;
using Risk.Forms.Helpers;
using Xamarin.Essentials.Interfaces;

namespace Risk.Forms.ViewModels
{
    public class LoginPageViewModel : ViewModelBase
    {
        private readonly IAutApi _autApi;
        private readonly ISecureStorage _secureStorage;

        public LoginPageViewModel(INavigationService navigationService,
            IAutApi autApi,
            ISecureStorage secureStorage) : base(navigationService)
        {
            _autApi = autApi;
            _secureStorage = secureStorage;
        }

        private string usuario;
        public string Usuario
        {
            get { return usuario; }
            set { SetProperty(ref usuario, value); }
        }

        private string clave;
        public string Clave
        {
            get { return clave; }
            set { SetProperty(ref clave, value); }
        }

        private bool isUsuarioInvalid;
        public bool IsUsuarioInvalid
        {
            get { return isUsuarioInvalid; }
            set { SetProperty(ref isUsuarioInvalid, value); }
        }

        private bool isClaveInvalid;
        public bool IsClaveInvalid
        {
            get { return isClaveInvalid; }
            set { SetProperty(ref isClaveInvalid, value); }
        }

        private DelegateCommand iniciarSesionCommand;
        public DelegateCommand IniciarSesionCommand =>
            iniciarSesionCommand ?? (iniciarSesionCommand = new DelegateCommand(ExecuteIniciarSesionCommand, CanExecuteIniciarSesionCommand));

        async void ExecuteIniciarSesionCommand()
        {
            UserDialogs.Instance.ShowLoading("Cargando...");
            SesionRespuesta sesionRespuesta = await _autApi.IniciarSesionAsync(new IniciarSesionRequestBody
            {
                Usuario = Usuario,
                Clave = Clave
            });
            UserDialogs.Instance.HideLoading();

            if (sesionRespuesta.Codigo.Equals("0"))
            {
                await _secureStorage.SetAsync(RiskConstants.ACCESS_TOKEN, sesionRespuesta.Datos.AccessToken);
                await _secureStorage.SetAsync(RiskConstants.REFRESH_TOKEN, sesionRespuesta.Datos.RefreshToken);

                var config = (Configuration)_autApi.Configuration;
                config.AccessToken = sesionRespuesta.Datos.AccessToken;

                App.IsUserLoggedIn = true;
                await NavigationService.NavigateAsync("/NavigationPage/MainPage");
            }
            else
            {
                await UserDialogs.Instance.AlertAsync(sesionRespuesta.Mensaje);
            }
        }

        bool CanExecuteIniciarSesionCommand()
        {
            if (Usuario == null || Clave == null)
            {
                return false;
            }

            if (!IsUsuarioInvalid && !IsClaveInvalid)
            {
                return true;
            }
            return false;
        }

        private DelegateCommand validateUsuarioCommand;
        public DelegateCommand ValidateUsuarioCommand =>
            validateUsuarioCommand ?? (validateUsuarioCommand = new DelegateCommand(ExecuteValidateUsuarioCommand, CanExecuteValidateUsuarioCommand));

        void ExecuteValidateUsuarioCommand()
        {
            IsUsuarioInvalid = string.IsNullOrEmpty(Usuario);
            IniciarSesionCommand.RaiseCanExecuteChanged();
        }

        bool CanExecuteValidateUsuarioCommand()
        {
            return true;
        }

        private DelegateCommand validateClaveCommand;
        public DelegateCommand ValidateClaveCommand =>
            validateClaveCommand ?? (validateClaveCommand = new DelegateCommand(ExecuteValidateClaveCommand, CanExecuteValidateClaveCommand));

        void ExecuteValidateClaveCommand()
        {
            IsClaveInvalid = string.IsNullOrEmpty(Clave);
            IniciarSesionCommand.RaiseCanExecuteChanged();
        }

        bool CanExecuteValidateClaveCommand()
        {
            return true;
        }
    }
}
