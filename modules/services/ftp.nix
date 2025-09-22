{ config, pkgs, lib, ... }: {
  # -------------------------------------------------
  # 1️⃣ Création de l’utilisateur système dédié FTP
  # -------------------------------------------------
  users.users.ftpuser = {
    isSystemUser = true;               # pas de login shell
    description   = "Compte FTP dédié";
    home          = "/srv/ftp/ftpuser";
    createHome    = true;
    group         = "ftpuser";
    shell         = "/usr/sbin/nologin";
  };
  users.groups.ftpuser = {};

  # -------------------------------------------------
  # 2️⃣ Permissions du répertoire home (méthode A)
  # -------------------------------------------------
  system.activationScripts.setupFtp = ''
    # Répertoire racine du chroot – lecture‑seule
    chmod a-w /srv/ftp/ftpuser
    # Sous‑répertoire où l’on peut écrire
    mkdir -p /srv/ftp/ftpuser/upload
    chown ftpuser:ftpuser /srv/ftp/ftpuser/upload
    chmod 755 /srv/ftp/ftpuser/upload
  '';

  # -------------------------------------------------
  # 3️⃣ Configuration du serveur vsftpd
  # -------------------------------------------------
  services.vsftpd = {
    enable = true;

    # Autoriser les comptes locaux (system users)
    localUsers = true;

    # Refuser l’accès anonyme (sécurité renforcée)
    anonymousUser = false;

    # Chroot chaque utilisateur local dans son $HOME
    chrootlocalUser = true;
    allowWriteableChroot = true ;

extraConfig = ''
    pasv_min_port=40000
    pasv_max_port=40004
  '';

  };

  # -------------------------------------------------
  # 4️⃣ Ouverture des ports dans le firewall NixOS
  # -------------------------------------------------
  networking.firewall = {
    allowedTCPPorts = [ 21 40000 40001 40002 40003 40004 ];
    # Si vous utilisez FTPS implicite (port 990) :
    # allowedTCPPorts = [ 21 990 40000 40001 40002 40003 40004 ];
  };
}

