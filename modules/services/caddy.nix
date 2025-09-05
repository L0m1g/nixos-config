_: {
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
}
