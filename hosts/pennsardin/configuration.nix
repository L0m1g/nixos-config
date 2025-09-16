{pkgs, ...}: {
  imports = [
    ../../profiles/workstation-bspwm.nix
    ../../modules/hardware/bepovim.nix
#    ../../modules/dev/qemu.nix
    ../../modules/common/nix.nix
  ];

  networking.hostName = "pennsardin";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.swraid.enable = true ;


  fileSystems."/" =
  { device = "/dev/disk/by-uuid/b1a1ae71-4277-45d5-a3d2-f49354f263d4";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/1DB2-7A0F";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  fileSystems."/proc" = 
  {
    device = "proc" ;
    fsType = "proc" ;
    options = [ "defaults" "hidepid=2" ];
    neededForBoot = true ;
  };

  fileSystems."/srv/raid" = 
  { device = "/dev/disk/by-uuid/85f72160-4720-463a-9dc6-7c5216733f2b";
    fsType = "btrfs";
  };

  swapDevices = [ ];

  users.users.lomig = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "lp" "wheel"];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.lomig = import ../../hm/users/lomig-desktop.nix;
  };

  system.stateVersion = "25.05"; # pour éviter les hurlements inutiles
}

# vim: set ts=2 sw=2 sts=2 et :

