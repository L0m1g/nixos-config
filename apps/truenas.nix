{ config, pkgs,  ... }:
{
  boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
  boot.extraModprobeConfig = ''
    options vfio-pci ids=1022:43f6
    '';
  boot.kernelParams = [
    "amd_iommu=on"
      "iommu=pt"
  ];
  users.users.lomig.extraGroups = [ "disk" ];
  security.pam.loginLimits = [
  { domain="lomig"; type="soft"; item="memlock"; value="infinity"; }
  { domain="lomig"; type="hard"; item="memlock"; value="infinity"; }
  ];
  boot.kernel.sysctl."vm.nr_hugepages" = 1024;
  fileSystems."/dev/hugepages" = { device="hugetlbfs"; fsType="hugetlbfs"; };

#  services.udev.extraRules = ''
#    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500b0179482", GROUP="disk", MODE="0660"
#    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500cc529430", GROUP="disk", MODE="0660"
#    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500cc53994a", GROUP="disk", MODE="0660"
#    SUBSYSTEM=="block", ENV{ID_SERIAL}=="wwn-0x50000c500cc5551d4", GROUP="disk", MODE="0660"
#    SUBSYSTEM=="vfio", GROUP="kvm", MODE="0660"
#    '';

  systemd.services.truenas-vm = {
    wantedBy = [ "multi-user.target" ]; 
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      RuntimeDirectory = "truenas" ;
      ExecStartPre = "/run/current-system/sw/bin/rm -f /run/truenas/qmp.sock";
      ExecStart = ''
        /run/current-system/sw/bin/qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 \
        -drive file=/home/lomig/vm/truenas.qcow2,if=none,format=qcow2,id=os \
        -device vfio-pci,host=0e:00.0 \
        -netdev bridge,br=br0,id=n1,helper=/run/wrappers/bin/qemu-bridge-helper \
        -device virtio-net-pci,netdev=n1,mac=52:54:00:00:01:02 \
        -device virtio-blk-pci,drive=os,bootindex=0 \
        -qmp unix:/run/truenas.qmp,server,nowait -display none
        '';
      ExecStop = ''
        echo '{"execute":"system_powerdown"}' | socat - UNIX-CONNECT:/run/truenas.qmp || true ; sleep 5
        ''; 
      Restart = "on-failure";
      RestartSec = 3 ;
      StartLimitIntervalSec = 60 ;
      StartLimitBurst = 5 ;
    };
  };

  systemd.services.resume-truenas-vm = {
    description = "Restart Truenas VM after resume" ;
    wantedBy = [ "sleep.target" ];
    after  = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot" ;
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart truenas-vm.service";
    };
  };
}

# vim: set ts=2 sw=2 sts=2 et :
