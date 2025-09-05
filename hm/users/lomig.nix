{pkgs, ...}: {
  imports = [
    ../common/nvim.nix
    ../../hm/common/git.nix
    ../../hm/common/zsh.nix
  ];
  home.stateVersion = "25.05"; # ou ton actuelle
  home = {
    username = "lomig";
    homeDirectory = "/home/lomig";
    packages = with pkgs; [
      bat
      tree
    ];
  };
  programs.zsh.enable = true;
}
# vim: set ts=2 sw=2 sts=2 et :

