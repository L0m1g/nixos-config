{ config, pkgs, ... }:
{
	programs.firefox = {
		enable = true ;
		languagePacks = [ "fr" ] ;
	};
}

# vim: set ts=2 sw=2 sts=2 et :
