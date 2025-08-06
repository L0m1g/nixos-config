{ config, pkgs, ... }:

{
  networking.hostName = "pennsardin";
  time.timeZone = "Europe/Paris";

  users.users.toto = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  services.xserver.enable = true;
}

