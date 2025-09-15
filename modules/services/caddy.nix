{ pkgs, ...}: {
  services.caddy = {
    enable = true;
    virtualHosts."blog.lomig.me" = {
      extraConfig = ''
        root * /var/www/lomig
        file_server
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  systemd.tmpfiles.rules = [
    "d /var/www/lomig 0755 lomig users -"
  ];
  systemd.services.hugo-blog-build = {
    description = "Build Hugo Blog";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = /home/lomig/scripts/blog-sync-and-build.sh;
      User = "lomig";
    };
  };

  systemd.timers.hugo-blog-build = {
    description = "Daily Hugo Blog Build";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily 06:00";
      Persistent = true;
    };
  };
}
