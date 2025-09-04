_: {
  services.logind.settings.Login = {
    IdleAction = "suspend";
    IdleActionSec = "5min";
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}
