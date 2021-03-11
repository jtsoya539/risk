using Android.Content;
using Risk.Forms.Droid;
using Risk.Forms.Helpers;
using Xamarin.Forms;

[assembly: Dependency(typeof(StartSettings))]
namespace Risk.Forms.Droid
{
    class StartSettings : IStartSettings
    {
        public void LaunchSettings()
        {
            Intent intentOpenSettings = new Intent();
            intentOpenSettings.SetFlags(ActivityFlags.ClearWhenTaskReset | ActivityFlags.NewTask);
            intentOpenSettings.SetAction(Android.Provider.Settings.ActionWifiSettings);
            Android.App.Application.Context.StartActivity(intentOpenSettings);
        }
    }
}