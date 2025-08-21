# modules/alerts/sms.nix

{ config, pkgs, lib, ... }:

let
  user = "21782061";  # Ton identifiant Free
  pass = "PEmCOQLKMEdMW9";  # Ta clé
in
{
  environment.systemPackages = with pkgs; [ curl ];
  environment.etc."mdadm-raid-wrapper.sh".text = ''
    systemctl start raid-alert-sms.service
  '';

  boot.swraid = {
    enable = true ;
    mdadmConf = ''
      MAILADDR guillaume.lame@protonmail.com
      PROGRAM /etc/mdadm-raid-wrapper.sh
      ARRAY /dev/md/raid-home UUID=cad7faf8:93cab941:ba745379:becc1918
      '';
  };

  fileSystems."/mnt/raid" = {
    device = "/dev/md/raid-home" ;
    fsType = "btrfs" ;
    options = ["compress=zstd" "noatime" "nofail" "x-systemd.device-timeout=5"];
  };

#  systemd.services.raid-alert-sms = {
#    description = "Envoie un SMS si RAID pète";
#    wantedBy = [ "multi-user.target" ];
#    serviceConfig = {
#      Type = "oneshot";
#      ExecStart = ''
#        ${pkgs.curl}/bin/curl -s \
#          "https://smsapi.free-mobile.fr/sendmsg?user=${user}&pass=${pass}&msg=TON+RAID+EST+MORT+FUIS"
#      '';
#    };
#  };

#  systemd.services.mdadm-monitor = {
#    description = "RAID monitoring";
#    wantedBy = [ "multi-user.target" ];
#    after = [ "network.target" ];
#    serviceConfig = {
#      ExecStart = "${pkgs.mdadm}/bin/mdadm --monitor --scan --daemonize --program=/etc/mdadm-raid-wrapper.sh";
#      Restart = "always";
#      RestartSec = "5s";
#      Type = "forking";
#    };
#  };
}

