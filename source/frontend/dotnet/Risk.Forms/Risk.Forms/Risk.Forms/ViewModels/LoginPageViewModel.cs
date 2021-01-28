using Acr.UserDialogs;
using Prism.Commands;
using Prism.Navigation;
using Risk.API.Client.Api;
using System.Threading.Tasks;

namespace Risk.Forms.ViewModels
{
    public class LoginPageViewModel : ViewModelBase
    {
        private readonly IAutApi _autApi;

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

        private bool isErrorVisible;
        public bool IsErrorVisible
        {
            get { return isErrorVisible; }
            set { SetProperty(ref isErrorVisible, value); }
        }

        private DelegateCommand iniciarSesionCommand;
        public DelegateCommand IniciarSesionCommand =>
            iniciarSesionCommand ?? (iniciarSesionCommand = new DelegateCommand(ExecuteIniciarSesionCommand, CanExecuteIniciarSesionCommand));

        async void ExecuteIniciarSesionCommand()
        {
            //_autApi.IniciarSesion(new API.Client.Model.IniciarSesionRequestBody { Usuario = Usuario, Clave = Clave });
            if (Usuario.Equals(Clave))
            {
                UserDialogs.Instance.ShowLoading("Cargando...");
                await Task.Delay(2000);
                App.IsUserLoggedIn = true;
                await NavigationService.NavigateAsync("/NavigationPage/MainPage");
                UserDialogs.Instance.HideLoading();
            }
            else
            {
                IsErrorVisible = true;
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

        public LoginPageViewModel(INavigationService navigationService, IAutApi autApi) : base(navigationService)
        {
            _autApi = autApi;
        }
    }
}
