_: {
  programs.dircolors.enableZshIntegration = true;
  programs.zsh = {
    autosuggestion.enable = true;
    dirHashes = {
      dl = "$HOME/Téléchargements";
      nix = "$HOME/nixos-config";
    };
    enable = true;
    enableCompletion = true;
    history = {
      append = true;
      extended = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      ignorePatterns = ["rm *" "cd *" "ls *" "df *" "du *" "fastfetch" "tree" "pwd" "upd"];
      saveNoDups = false;
    };
    shellAliases = {
      h = "history";
      upd = "sudo nixos-rebuild switch --flake $HOME/nixos-config#pennsardin; source ~/.zshrc";
    };
    shellGlobalAliases = {
      G = "| grep";
      M = "| more";
    };
    syntaxHighlighting.enable = true;
  };
}
# vim: set ts=2 sw=2 sts=2 et :

