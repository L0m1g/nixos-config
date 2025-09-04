{pkgs, ...}: {
  imports = [
    ../../hm/common/browser.nix
    ../common/nvim.nix
    ../../hm/common/zsh.nix
    ../desktop/bspwm.nix
  ];
  home.stateVersion = "25.05"; # ou ton actuelle
  home = {
    username = "lomig";
    homeDirectory = "/home/lomig";
    packages = with pkgs; [
      bat
      fastfetch
      nerd-fonts.iosevka
      obsidian
      smug
      telegram-desktop
      tree
    ];
  };
  programs.zsh.enable = true;
}
# vim: set ts=2 sw=2 sts=2 et :

