{lib, ...}: {
  services = {
    displayManager = {
      gdm.enable = true;
      sddm.enable = lib.mkForce false;
    };
    desktopManager = {
      gnome.enable = true;
      plasma6.enable = lib.mkForce false;
    };
    xserver = {
      windowManager.bspwm.enable = lib.mkForce false;
      displayManager.lightdm.enable = lib.mkForce false;
    };
  };
}
# vim: set ts=2 sw=2 sts=2 et :

