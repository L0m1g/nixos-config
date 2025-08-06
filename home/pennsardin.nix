{ config, pkgs, ... }:

{
  home.username = "lomig";
  home.homeDirectory = "/home/lomig";

  programs.zsh.enable = true;
  home.stateVersion = "25.05"; # ou ton actuelle
}

