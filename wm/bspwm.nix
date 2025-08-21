{ config, pkgs, ... }:
{
	services.xserver = {
		enable = true ;
		displayManager.lightdm.enable = true ;
		windowManager.bspwm.enable = true ;
	};
	home-manager.users.lomig = { pkgs, ... }: {
		home.packages = with pkgs; [
			bspwm sxhkd xorg.xinit xterm
				alacritty rofi feh font-awesome
				picom xorg.xset xidlehook betterlockscreen
				pywal16 imagemagick
		];

		xsession.enable = true ;
		xsession.initExtra =  ''
			xset s 300 300
			xset s on
			xsession s noblank

			xset +dpms
			xset dpms 0 0 500
			'';
		systemd.user.services.xidlehook = {
			Unit.Description = "Idle actions (lock at 1m, suspend at 5m)";
			Service = {
				ExecStart = ''
					${pkgs.xidlehook}/bin/xidlehook \
					--detect-sleep \
					--not-when-fullscreen \
					--timer 300  "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim" "" \
					--timer 500 "systemctl suspend" ""
					'';
				Restart = "always";
			};
			Install.WantedBy = [ "graphical-session.target" ];
		};

		xsession.windowManager.bspwm = {
			enable = true ;
			startupPrograms = [
				"killall polybar"
					"setxkbmap bepovim"
					"sxhkd -m 1"
					"xrandr \\
					--output DisplayPort-1 --rate 60 --pos 0x0"
					"while pgrep -x polybar >/dev/null; do sleep 0.2; done"
					"polybar"
          "bash ~/.fehbg"
			];
			extraConfig = ''
				bspc config borderless_monocle true
				bspc config gapless_monocle true
				bspc config single_monocle true
				bspc monitor -d I II III IV V VI
				'';
		};
		services.sxhkd = {
			enable = true ;
			extraOptions = [ "-m 1" ] ;
			keybindings = {
				"super + Return" = "alacritty";
				"super + c" = "bspc node -c";
				"Menu" = "rofi -show drun";
				"super + space" = "rofi -show drun";

# Aller au bureau ^1 .. ^6
				"F1" = "bspc desktop -f ^1";
				"F2" = "bspc desktop -f ^2";
				"F3" = "bspc desktop -f ^3";
				"F4" = "bspc desktop -f ^4";
				"F5" = "bspc desktop -f ^5";
				"F6" = "bspc desktop -f ^6";

# Déplacer la fenetre courante vers le bureau cible et suivre
				"shift + F1" = "bspc node -d ^1 --follow";
				"shift + F2" = "bspc node -d ^2 --follow";
				"shift + F3" = "bspc node -d ^3 --follow";
				"shift + F4" = "bspc node -d ^4 --follow";
				"shift + F5" = "bspc node -d ^5 --follow";
				"shift + F6" = "bspc node -d ^6 --follow";

# Focus dans un meme bureau
				"super + h" = "bspc node -f west";
				"super + j" = "bspc node -f south";
				"super + k" = "bspc node -f north";
				"super + l" = "bspc node -f east";

# Swap la fenetre dans le bureau
				"super + shift + h" = "bspc node -s west";
				"super + shift + j" = "bspc node -s south";
				"super + shift + k" = "bspc node -s north";
				"super + shift + l" = "bspc node -s east";
			};
		};

		services.polybar = {
			enable = true ;
			script = "polybar main &";
			config = {
				"bar/main" = {
					width = "100%";
					height = "28";
					background = "\\\${colors.background}";
					foreground = "\\\${colors.foreground}";
					font-0 = "Iosevka Nerd Font:size=10;2";
					font-1 = "Font Awesome 6 Free:style=Solid:pixelsize=10;2";
					modules-left = "bspwm";
					modules-center = "date";
					modules-right = "pulseaudio memory cpu";
				};

				"module/bspwm" = {
					type = "internal/bspwm";
					label-focused = "%name%";
					label-focused-background = "\\\${colors.primary}";
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
		programs.alacritty.enable = true ;
		programs.alacritty.settings = {
			general.import = [
				"~/.cache/wal/colors-alacritty.toml"
			];
			font = {
				normal = { family = "Iosevka Nerd Font"; style = "Regular"; };
				bold   = { family = "Iosevka Nerd Font"; style = "Bold"; };
				italic = { family = "Iosevka Nerd Font"; style = "Italic"; };
				size = 9;
			};
		};


		programs.floorp = {
			enable = true ;
			languagePacks = [ "fr" ] ;
		};
	};
}

# vim: set ts=2 sw=2 sts=2 et :
