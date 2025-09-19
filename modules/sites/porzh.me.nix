{ config, pkgs, ... }:

let
  porzhSite = pkgs.stdenv.mkDerivation {
    pname = "porzh-site";
    version = "1.0";
    src = ./porzh.me;  # le dossier avec ton index.html, image, etc.

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
in {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "porzh.me" = {
        serverAliases = [ "www.porzh.me" ];
        extraConfig = ''
          root * ${porzhSite}
          file_server
        '';
      };
    };
  };
}

