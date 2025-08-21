{ config, pkgs,  ... }:
{
  boot.kernelModules = [ "tun" ];
  
  environment.systemPackages = with pkgs; [
    qemu_kvm
  ];
  services.spice-vdagentd.enable = true;
  virtualisation.libvirtd = {
    enable = true ;
    qemu = {
      swtpm.enable = true ;
      ovmf.enable = true ;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
      runAsRoot = false ;
    };
  };

  users.users.lomig.extraGroups = [ "libvirtd" "kvm" "input" ];
  networking.firewall.allowedTCPPorts = [ 5900 5901 5902 ] ;
  networking.useNetworkd = true ;
  networking.useDHCP = false ;
  services.resolved.enable = true ;
  networking.bridges.br0.interfaces = [ "enp11s0" ];

  systemd.network.networks."10-br0" = {
    matchConfig.Name = "br0";
    networkConfig.DHCP = "yes" ;
  };

#  security.wrappers.qemu-bridge-helper = {
#    source = "${pkgs.qemu_kvm}/libexec/qemu-bridge-helper";
#    owner = "root";
#    group = "root";
#    setuid = true ;
#    permissions = "u+xs,g+x,o-x";
#  };

  environment.etc."qemu/bridge.conf".text = ''
    allow br0
  '';
}
# vim: set ts=2 sw=2 sts=2 et :
