using Acr.UserDialogs;
using Prism.Commands;
using Prism.Navigation;
using System.Threading.Tasks;

namespace Risk.Forms.ViewModels
{
    public class MainPageViewModel : ViewModelBase
    {
        public MainPageViewModel(INavigationService navigationService)
            : base(navigationService)
        {
            Title = "Main Page";
        }

        private DelegateCommand finalizarSesionCommand;
        public DelegateCommand FinalizarSesionCommand =>
            finalizarSesionCommand ?? (finalizarSesionCommand = new DelegateCommand(ExecuteFinalizarSesionCommand, CanExecuteFinalizarSesionCommand));

        async void ExecuteFinalizarSesionCommand()
        {
            UserDialogs.Instance.ShowLoading("Cargando...");
            await Task.Delay(2000);
            App.IsUserLoggedIn = false;
            await NavigationService.NavigateAsync("/LoginPage");
            UserDialogs.Instance.HideLoading();
        }

        bool CanExecuteFinalizarSesionCommand()
        {
            return true;
        }
    }
}
