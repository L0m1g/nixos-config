{
  config,
  lib,
  ...
}: {
  boot.kernelModules = lib.mkAfter ["zenpower"];
  boot.extraModulePackages = [config.boot.kernelPackages.zenpower];
  hardware.sensor.iio.enable = lib.mkDefault true;
  services.hardware.bolt.enable = lib.mkDefault false;
}
# vim: set ts=2 sw=2 sts=2 et :

