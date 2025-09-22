{pkgs, ...}: {
  imports = [
    ../common/nix.nix

    # Matériel
    ../hardware/gpu-amd.nix
    ../hardware/sensors-zenpower.nix

    # Virtualisation/tuning
    ../virtual/kvm-amd.nix
    ../virtual/vfio.nix

    # Dev
#    ../dev/qemu.nix
#    ../virtual/truenas.nix # seulement si tu l’utilises sur ce host
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    ripgrep
    fd
    pciutils
    usbutils
    p7zip
    gdu
    glances
    parted
    tmux
    discord
  ];
}
