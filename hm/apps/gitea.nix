_: let
  domain = "git.lomig.me"; # <-- mets ton domaine
  giteaHttpPort = 3000; # port local de Gitea
in {
  ########################################
  # Base système
  ########################################
  networking.firewall.allowedTCPPorts = [80 443 22]; # HTTP(S) + SSH (22)
  services = {
    openssh.enable = true; # si tu veux aussi OpenSSH pour le reste

    ########################################
    # Base de données Postgres
    ########################################
    postgresql = {
      enable = true;
      ensureDatabases = ["gitea"];
      ensureUsers = [
        {
          name = "gitea";
          ensureDBOwnership = true;
        }
      ];
    };

    ########################################
    # Gitea
    ########################################
    gitea = {
      enable = true;
      appName = "Gitea";
      user = "gitea"; # user système service
      database = {
        type = "postgres";
        user = "gitea";
        name = "gitea";
        host = "127.0.0.1";
      };
    };

    # Répertoire de données (par défaut: /var/lib/gitea)
    stateDir = "/var/lib/gitea";

    # Réglages gitea.ini
    settings = {
      server = {
        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = giteaHttpPort;
        DOMAIN = domain;
        ROOT_URL = "https://${domain}/";
        SSH_DOMAIN = domain;

        # SSH intégré par Gitea (pratique : pas besoin de configurer un port séparé)
        START_SSH_SERVER = true;
        SSH_LISTEN_PORT = 2222; # port interne Gitea
        SSH_PORT = 22; # port public affiché dans les URLs clone
      };

      service = {
        DISABLE_REGISTRATION = true; # tu créeras les comptes toi‑même
        REQUIRE_SIGNIN_VIEW = false;
        REGISTER_EMAIL_CONFIRM = true;
      };

      # SMTP (remplace par ton vrai relais)

      log = {
        MODE = "console";
        LEVEL = "Info";
      };
    };

    # Création d'un admin au premier démarrage (facultatif mais pratique)
    # Remplace le mot de passe et l’email :
    # L'utilisateur est créé si inexistant.
  };

  ########################################
  # Caddy reverse proxy + TLS
  ########################################
  services.caddy = {
    enable = true;
    virtualHosts."${domain}".extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString giteaHttpPort}
    '';
    # Par défaut, Caddy va récupérer un certificat Let's Encrypt pour le domaine public
    # Si domaine local sans DNS public, ajoute `tls internal` dans extraConfig.
  };
}
# vim: set ts=2 sw=2 sts=2 et :

