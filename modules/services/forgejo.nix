# NixOS module Forgejo avec SQLite, SSH et reverse proxy Caddy
{ config, pkgs, lib, ... }: {

  # --- Utilisateur dédié ---
  users.users.git = {
    isSystemUser = true;
    home = "/var/lib/forgejo";
    shell = pkgs.bash;
    group = "git";
  };
  users.groups.git = {};

  # --- Forgejo ---
  services.forgejo = {
    enable = true;
    user = "git";
    group = "git";
    database = {
      type = "sqlite3";
      path = "/var/lib/forgejo/data/gitea.db";
    };
    settings = {
      server = {
        DOMAIN = "govel.porzh.me";
        ROOT_URL = "https://govel.porzh.me/";
        SSH_DOMAIN = "govel.porzh.me";
        HTTP_PORT = 3000;
        SSH_PORT = 22;
        START_SSH_SERVER = false;
      };
      service = {
        DISABLE_REGISTRATION = true;
        REGISTER_EMAIL_CONFIRM = false;
      };
      repository = {
        DEFAULT_BRANCH = "main";
      };
    };
  };

  # --- Ouvrir les ports nécessaires ---
  networking.firewall.allowedTCPPorts = [ 80 443 2222 ];

  # --- Rediriger port SSH interne de Forgejo ---
  services.openssh.enable = true;
  networking.firewall.interfaces."eth0".allowedTCPPorts = [ 22 ]; # pour admin

  # --- Caddy pour govel.porzh.me ---
  services.caddy = {
    enable = true;
    virtualHosts."govel.porzh.me" = {
      extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
  };

  # --- Pour que Forgejo génère les bonnes URLs Git ---
#  networking.hostName = "git"; # non strictement obligatoire

  # --- Optionnel : config DNS ---
  # git.lomig.me -> ton IP publique (ou IP locale si LAN)

  # --- Pour te cloner un dépôt : ---
  # git clone git@git.lomig.me:lomig/nom-du-repo.git

  # --- Astuce : génère une paire de clés pour l’accès SSH Git ---
  # ssh-keygen -t ed25519 -f ~/.ssh/id_git_forgejo
  # puis ajoute la clé publique dans ton compte Forgejo

}

