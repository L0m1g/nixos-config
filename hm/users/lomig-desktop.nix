{pkgs, ...}: {
  imports = [
    ../desktop/bspwm.nix
    ./lomig.nix
  ];
  home.stateVersion = "25.05"; # ou ton actuelle
  home = {
    packages = with pkgs; [
      fastfetch
      nerd-fonts.iosevka
      obsidian
      smug
      telegram-desktop
    ];
  };
}
# vim: set ts=2 sw=2 sts=2 et :

