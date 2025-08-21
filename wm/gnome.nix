{ config, pkgs, lib, ... }:
{
  services = {
    displayManager = {
      gdm = {
        enable = true ;
      };
    };
    desktopManager.gnome.enable = true ;
    xserver = {
      windowManager.bspwm.enable = lib.mkForce false ;
      displayManager.lightdm.enable = lib.mkForce false ;
    };
  };
}

# vim: set ts=2 sw=2 sts=2 et :
