{ config, pkgs, ... }:
{
	services = {
		displayManager.gdm = {
      enable = true ;
      };
		desktopManager.gnome.enable = true ;
	};
}

# vim: set ts=2 sw=2 sts=2 et :
