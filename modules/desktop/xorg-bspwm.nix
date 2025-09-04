{
  config,
  lib,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
      };
      windowManager.bspwm.enable = true ;
    };
    displayManager = {
      gdm.enable = lib.mkForce false;
      sddm.enable = lib.mkForce false;
    };
    desktopManager = {
      gnome.enable = lib.mkForce false;
      plasma6.enable = lib.mkForce false;
    };
  };
}
# vim: set ts=2 sw=2 sts=2 et :

