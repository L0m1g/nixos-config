{
  lib,
  pkgs,
  ...
}: {
  boot = {
    plymouth.enable = true;
    plymouth.theme = "spinner";
    consoleLogLevel = 3;
    initrd.verbose = false;

    # Ajouts "quiet/splash" propres (sans auto-référence)
    kernelParams = lib.mkAfter [
      "mem_sleep_default=deep"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    loader = {
      timeout = 5;
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nixos-bgrt-plymouth
  ];
}
