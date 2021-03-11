using Risk.Forms.Helpers;
using Risk.Forms.UWP;
using System;
using Xamarin.Forms;

[assembly: Dependency(typeof(StartSettings))]
namespace Risk.Forms.UWP
{
    class StartSettings : IStartSettings
    {
        public void LaunchSettings()
        {
            _ = Windows.System.Launcher.LaunchUriAsync(new Uri("ms-settings:"));
        }
    }
}
