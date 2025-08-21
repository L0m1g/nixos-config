{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    backend = "glx"; # plus fluide si ta carte gère bien OpenGL
    fade = true;
    fadeDelta = 5;   # vitesse fondu
    shadow = true;
    shadowOpacity = 0.5;
    vSync = true;    # évite le tearing

    settings = {
      # Transparence
      inactive-opacity = 0.80;
      active-opacity   = 0.9;
      frame-opacity    = 0.90;
      inactive-opacity-override = false;

      # Coins arrondis
      corner-radius = 8;
      round-borders = 1;
      rounded-corners-exclude = [
        "class_g = 'Polybar'"
        "class_g = 'Rofi'"
      ];

      # Flou subtil
      blur-method = "dual_kawase";
      blur-strength = 4;
      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = false;
      blur-background-exclude = [
        "class_g = 'Polybar'"
        "class_g = 'Rofi'"
	"class_g = 'Gimp'"
        "window_type = 'dock'"
      ];

      # Exclusions ombres
      shadow-exclude = [
        "class_g = 'Polybar'"
        "class_g = 'Rofi'"
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
    };
  };
}

