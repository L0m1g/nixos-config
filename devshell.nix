{pkgs}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    alejandra # formatteur nix officiel (rapide)
    statix # linting pour repérer mauvaises pratiques
    deadnix # détecte le code mort / imports inutiles
  ];

  shellHook = ''
    echo "Tools dispo :"
    echo "  alejandra .    # formate tout ton Nix"
    echo "  statix check   # lint"
    echo "  deadnix .      # cherche le code mort"
  '';
}
