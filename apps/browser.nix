{ config, pkgs, ... }:
{
programs.floorp = {
  enable = true ;
  languagePacks = [ "fr" ] ;
  };
programs.firefox = {
  enable = true ;
  languagePacks = [ "fr" ] ;
  };
}
