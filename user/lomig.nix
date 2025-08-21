{ config, pkgs, lib, desktop, ... }:

{
  imports = [
    ../apps/browser.nix
    ../apps/picom.nix
    ../apps/zsh.nix
  ];
  home.username = "lomig";
  home.homeDirectory = "/home/lomig";
  home.packages = with pkgs; [
    bat
    nerd-fonts.iosevka
    obsidian
    telegram-desktop
    tree
    fastfetch
  ];

  programs.zsh.enable = true;
  home.stateVersion = "25.05"; # ou ton actuelle
}

