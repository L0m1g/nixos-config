{
  lib,
  pkgs,
  ...
}: {
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    firmware = [pkgs.linux-firmware];
    firmwareCompression = "zstd";
    enableRedistributableFirmware = true;
  };
}
