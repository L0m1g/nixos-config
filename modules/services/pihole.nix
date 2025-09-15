{
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    autoStart = true;

    ports = [
      "53:53/udp"
      "53:53/tcp"
      "80:80/tcp"
    ];

    environment = {
      TZ = "Europe/Paris";
      WEBPASSWORD = "changeme";  # Change à ta convenance
      PIHOLE_DNS_ = "1.1.1.1;1.0.0.1";
    };

    volumes = [
      "/srv/pihole/etc-pihole:/etc/pihole"
      "/srv/pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
    ];
    extraOptions = [ "--cap-add=NET_ADMIN" ];
  };
}
