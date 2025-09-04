{
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.kernelModules = lib.mkAfter ["amdgpu"];
    kernelModules = lib.mkAfter ["amdgpu"];
  };

  # Pilotes + options AMDGPU
  services.xserver = {
    enable = true;
    videoDrivers = lib.mkDefault ["amdgpu"];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libva
      libva-utils
      libvdpau
      libva-vdpau-driver
      vaapiVdpau
      libvdpau-va-gl
      amdvlk
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "va_gl";
  };

  # Désactive héritage radeon pour cartes anciennes
  boot.kernelParams = lib.mkAfter [
    "amdgpu.si_support=0"
    "amdgpu.cik_support=0"
    "radeon.si_support=0"
    "radeon.cik_support=0"
  ];

  # Si un module sonde "k10temp" gêne :
  boot.blacklistedKernelModules = ["k10temp"];
}
