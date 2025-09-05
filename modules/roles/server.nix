{pkgs, ...}: {
  imports = [
    ../common/nix.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    ripgrep
    fd
    pciutils
    usbutils
    p7zip
    gdu
    glances
    tmux
  ];
}
