# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ../../profiles/server-selfhosted.nix
      ../../modules/services/ftp.nix
      ../../modules/services/forgejo.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "terre-neuvas"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  users.users.lomig = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "lp" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.lomig = import ../../hm/users/lomig.nix;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     git
     hugo
  ];
  networking.firewall.allowedTCPPorts = [ 80 ];
  system.stateVersion = "25.05"; # Did you read the comment?
}
