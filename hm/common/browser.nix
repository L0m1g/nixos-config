{pkgs, nur, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = ["fr"];
    profiles.default = {
      settings = {
        "intl.locale.requested" = "fr" ;
        "intl.accept_languages" = "fr, en-US, en";
        "privacy.trackingprotection.enabled" = true ;
        "privacy.resistFingerprinting" = true ;
        "network.cookie.cookieBehavior" = 1;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        i-dont-care-about-cookies
        privacy-badger
        proton-pass
        ublock-origin
      ];
    };
  };
                   }
# vim: set ts=2 sw=2 sts=2 et :

