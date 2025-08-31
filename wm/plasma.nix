{ config, pkgs, lib, ... }:
{
  services = {
    displayManager = {
      gdm.enable = lib.mkForce false ;
      sddm.enable = true ;
    };
    desktopManager = {
      gnome.enable = lib.mkForce false ;
      plasma6.enable = true ;
    };
    xserver = {
      windowManager.bspwm.enable = lib.mkForce false ;
      displayManager.lightdm.enable = lib.mkForce false ;
    };
  };
}

# vim: set ts=2 sw=2 sts=2 et :
