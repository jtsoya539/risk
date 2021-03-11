using Prism.Commands;
using Prism.Mvvm;
using Risk.Forms.Helpers;
using Xamarin.Forms;

namespace Risk.Forms.ViewModels
{
    public class NoConnectionPageViewModel : BindableBase
    {
        public NoConnectionPageViewModel()
        {

        }

        private DelegateCommand _configurarCommand;
        public DelegateCommand ConfigurarCommand =>
            _configurarCommand ?? (_configurarCommand = new DelegateCommand(ExecuteConfigurarCommand));

        void ExecuteConfigurarCommand()
        {
            DependencyService.Get<IStartSettings>().LaunchSettings();
        }
    }
}
