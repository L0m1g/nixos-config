{pkgs, ...}: {
  imports = [
    ../modules/roles/server.nix
    ../modules/common/base.nix
    ../modules/common/networking.nix
    ../modules/services/printing.nix
    ../modules/sites/porzh.me.nix
  ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    btrfs-progs
    cifs-utils
    lm_sensors
  ];
}
# vim: set ts=2 sw=2 sts=2 et :

