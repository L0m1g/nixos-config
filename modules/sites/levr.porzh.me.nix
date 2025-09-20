{ config, pkgs, ... }:
{
  # -----------------------------------------------------------------
  # 1️⃣ Caddy (reverse‑proxy / serveur web statique)
  # -----------------------------------------------------------------
  services.caddy = {
    enable = true;

    # Caddy démarre en tant qu’utilisateur « caddy ».
    # On lui donne accès au répertoire du blog via les ACL créées plus haut.
    # (Pas besoin de config supplémentaire côté OS.)

    # -----------------------------------------------------------------
    # 2️⃣ Sites gérés par Caddy (Caddyfile intégré)
    # -----------------------------------------------------------------
    virtualHosts = {
      "levr.porzh.me" = {
        # Le domaine sera automatiquement provisionné avec TLS via ACME
        # (Let's Encrypt) grâce à l’option `autoHTTPS = true` (défaut).
        # Aucun certificat manuel n’est requis.

        # Le répertoire contenant les fichiers générés par Hugo

        # (Optionnel) Rediriger HTTP → HTTPS – Caddy le fait déjà,
        # mais on le rend explicite pour la clarté.
        extraConfig = ''
          @http {
            protocol http
          }
          redir @http https://{host}{uri} permanent
          root * /srv/blog/public
          file_server
        '';
      };
    };
  };

  # -----------------------------------------------------------------
  # 3️⃣ Ouverture du firewall (ports 80 et 443)
  # -----------------------------------------------------------------
  networking.firewall.allowedTCPPorts = [
    80   # HTTP (pour la redirection ACME)
    443  # HTTPS (site final)
  ];
}
