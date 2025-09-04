_: {
  networking = {
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "8.8.8.8"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    firewall.enable = true;
  };
}
