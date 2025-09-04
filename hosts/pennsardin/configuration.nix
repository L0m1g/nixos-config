{pkgs, ...}: {
  imports = [
    ../../profiles/workstation-bspwm.nix
    ../../modules/hardware/bepovim.nix
    ../../modules/dev/qemu.nix
    ../../modules/common/nix.nix
  ];

  networking.hostName = "pennsardin";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b4e3577b-17ab-4a89-9aeb-4e223be4c75b"; # à adapter si tu as un autre label/disque
    fsType = "ext4"; # ou btrfs, xfs, ce que t'as utilisé
  };
  swapDevices = [];

  users.users.lomig = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "lp" "wheel"];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.lomig = import ../../hm/users/lomig.nix;
  };

  system.stateVersion = "25.05"; # pour éviter les hurlements inutiles
}
# vim: set ts=2 sw=2 sts=2 et :

