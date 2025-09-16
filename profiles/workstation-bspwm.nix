{pkgs, ...}: {
  imports = [
    ../modules/roles/workstation.nix
    ../modules/desktop/xorg-bspwm.nix
    ../modules/common/base.nix
    ../modules/common/fonts.nix
    ../modules/common/networking.nix
    ../modules/common/plymouth.nix
    ../modules/hardware/firmware.nix
    ../modules/hardware/gpu-amd.nix
    ../modules/common/audio.nix
    ../modules/common/bluetooth.nix
    ../modules/common/gaming.nix
    ../modules/services/printing.nix
    ../modules/common/lockscreen.nix
    ../modules/common/energy.nix
  ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    btrfs-progs
    cifs-utils
    evtest
    lm_sensors
    xorg.xev
    xorg.xkbcomp
  ];
}
# vim: set ts=2 sw=2 sts=2 et :

