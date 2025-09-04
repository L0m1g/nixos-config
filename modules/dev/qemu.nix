{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../virtual/truenas.nix
  ];
  boot.kernelModules = lib.mkAfter ["tun"];
  environment.systemPackages = with pkgs; [
    qemu_kvm
    virtiofsd
  ];

  services = {
    udev.extraRules = ''
      #    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500b0179482", GROUP="disk", MODE="0660"
      #    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500cc529430", GROUP="disk", MODE="0660"
      #    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500cc53994a", GROUP="disk", MODE="0660"
      #    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500cc5551d4", GROUP="disk", MODE="0660"
          SUBSYSTEM=="vfio", GROUP="kvm", MODE="0660"
    '';
    spice-vdagentd.enable = true;
    resolved.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
      ovmf.packages = [pkgs.OVMFFull.fd];
      runAsRoot = false;
    };
  };

  users.users.lomig.extraGroups = ["libvirtd" "kvm" "input"];
  networking = {
    firewall.allowedTCPPorts = [5900 5901 5902];
    useDHCP = false;
    bridges.br0.interfaces = ["enp11s0"];
  };

  systemd.network.networks."10-br0" = {
    matchConfig.Name = "br0";
    networkConfig.DHCP = "yes";
  };

  environment.etc."qemu/bridge.conf".text = ''
    allow br0
  '';
}
# vim: set ts=2 sw=2 sts=2 et :

