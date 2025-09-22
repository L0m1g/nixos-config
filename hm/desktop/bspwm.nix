# hm/desktop/bspwm.nix
{ pkgs, lib, ... }:
{
  imports = [
    ../common/browser.nix
  ];
  home.packages = with pkgs; [
    bspwm sxhkd xorg.xinit xterm alacritty rofi feh font-awesome
    picom xorg.xset xidlehook betterlockscreen pywal16 imagemagick
    pulsemixer ranger jq file highlight unzip mpv
    protonvpn-gui
  ];

  # Gère le ssh-agent proprement côté user
  services.ssh-agent.enable = true;

  xsession.enable = true;
  xsession.windowManager.bspwm = {
    enable = true;

    # Démarrages au login X
    startupPrograms = [
      "sxhkd -m 1"
      "setxkbmap bepovim"
      "xrandr --output DisplayPort-1 --rate 60 --pos 0x0"
#      "while pgrep -x polybar >/dev/null; do sleep 1; done; polybar main"
      "bash ~/.fehbg"
    ];

    extraConfig = ''
      bspc config borderless_monocle true
      bspc config gapless_monocle true
      bspc config single_monocle true
      bspc monitor -d I II III IV V VI
    '';
  };

#  xsession.initExtra = ''
#    xset s 300 300
#    xset s on
#    xset s noblank
#    xset +dpms
#    xset dpms 0 0 500
#  '';

  services.sxhkd = {
    enable = true;
    extraOptions = [ "-m" "1" ];
    keybindings = {
      "super + Return" = "alacritty";
      "super + c" = "bspc node -c";
      "Menu" = "rofi -show drun";
      "super + space" = "rofi -show drun";

      "F1" = "bspc desktop -f ^1";
      "F2" = "bspc desktop -f ^2";
      "F3" = "bspc desktop -f ^3";
      "F4" = "bspc desktop -f ^4";
      "F5" = "bspc desktop -f ^5";
      "F6" = "bspc desktop -f ^6";

      "shift + F1" = "bspc node -d ^1 --follow";
      "shift + F2" = "bspc node -d ^2 --follow";
      "shift + F3" = "bspc node -d ^3 --follow";
      "shift + F4" = "bspc node -d ^4 --follow";
      "shift + F5" = "bspc node -d ^5 --follow";
      "shift + F6" = "bspc node -d ^6 --follow";

      "super + h" = "bspc node -f west";
      "super + j" = "bspc node -f south";
      "super + k" = "bspc node -f north";
      "super + l" = "bspc node -f east";

      "super + shift + h" = "bspc node -s west";
      "super + shift + j" = "bspc node -s south";
      "super + shift + k" = "bspc node -s north";
      "super + shift + l" = "bspc node -s east";

      "super + f" = "bspc node -t fullscreen";
      "super + s" = "bspc node -t floating";
      "super + shift + t" = "bspc node -t pseudo_tiled";
      "super + t" = "bspc node -t tiled";
    };
  };

  # xidlehook (user service)
  systemd.user.services.xidlehook = {
    Unit.Description = "Idle: lock at 5min, suspend at ~8min";
    Service = {
      ExecStart = ''
        ${pkgs.xidlehook}/bin/xidlehook \
          --detect-sleep \
          --not-when-fullscreen \
          --timer 300  "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim" "" \
          --timer 500  "systemctl suspend" ""
      '';
      Restart = "always";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # polybar (config intégrée pour démarrer simple)
  services.polybar = {
    enable = true;
    script = "polybar main &";
    config = {
      "bar/main" = {
        width = "100%";
        height = "28";
        font-1 = "Font Awesome 6 Free:style=Solid:pixelsize=10;2";
        modules-left = "bspwm";
        modules-center = "date";
        modules-right = "pulseaudio memory cpu";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        label-focused = "%name%";
        label-focused-foreground = "#e6e0de";
        label-focused-padding = 2;
        label-occupied = "%name%";
        label-occupied-padding = 2;
        label-urgent = "%name%";
        label-urgent-background = "#e42127";
        label-urgent-foreground = "#ffffff";
        label-empty = "%name%";
        label-empty-foreground = "#645d56";
        label-empty-padding = 2;
      };
      "module/date" = {
        type = "internal/date";
        interval = 60;
        date = "%d-%m-%Y %H:%M";
      };
    };
  };

  # alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ "~/.cache/wal/colors-alacritty.toml" ];
      font = {
        normal = { family = lib.mkForce "Iosevka Nerd Font"; style = "Regular"; };
        bold   = { family = lib.mkForce "Iosevka Nerd Font"; style = "Bold"; };
        italic = { family = lib.mkForce "Iosevka Nerd Font"; style = "Italic"; };
        size = lib.mkForce 9;
      };
    };
  };

  programs.rtorrent = {
    enable = true ;
    extraConfig = ''
      directory = /srv/raid
      port_range = 6881-6891
      max_peers = 150
      max_peers_seed = 100
      protocol.pex.set = true ;
      schedule = watch_directory,5,5,load.start=~/Téléchargements/*.torrent
      pieces.hash.on_completion.set = no
      network.max_open_files.set = 8192
      session = /home/lomig/.cache/rtorrent/session
'';
  };
  home.activation.createRtorrentSessionDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.cache/rtorrent/session
  '';
}

