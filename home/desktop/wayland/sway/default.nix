{ homeSettings, config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.desktop.wayland.sway;
in {
	imports = [
		./keybindings.nix
		./waybar.nix
	];

	options.jbury.nixrc.home.modules.desktop.wayland.sway = {
		enable = mkEnableOption "sway";
	};

	config = mkIf cfg.enable {
		wayland.windowManager.sway = {
			enable = true;
			xwayland = true;

			config = {
				terminal = "${pkgs.foot}/bin/foot";

				window.titlebar = false;
				floating.titlebar = false;

				focus = {
					followMouse = false;
					mouseWarping = "container";
					newWindow = "smart";
				};

				gaps = {
					inner = 8;
					smartGaps = true;
				};

				output = {
					eDP-1 = {
						mode = "2256x1504@60Hz";
						position = "1184,1440";
						scale = "1.0";
					};
					# Ultrawide
					"ASUSTek COMPUTER INC ASUS VG35V 0x000207A6" = {
						mode = "3440x1440@30Hz";
						position = "0,0";
						scale = "1.0";
					};
					## 4K
					#"LG Electronics LG ULTRAGEAR+ 405NTWG5L201" = {
					#	mode = "3840x2160@30Hz";
					#	position = "3440,720";
					#	scale = "1.0";
					#};
				};

				workspaceOutputAssign = [
					{
						output = "eDP-1";
						workspace = "1";
					}
					{
						output = "ASUSTek COMPUTER INC ASUS VG35V 0x000207A6";
						workspace = "2";
					}
					#{
					#	output = "LG Electronics LG ULTRAGEAR+ 405NTWG5L201";
					#	workspace = "3";
					#}
				];

				bars = [ ];

				startup = [
					#{
					#	command = "$DOTFILES/bin/laptop.sh";
					#	always = true;
					#}
					{
						command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob";
						always = false;
					}
					{
						command = "${pkgs.autotiling}/bin/autotiling";
						always = false;
					}
					{
						command = "${pkgs.swayr}/bin/swayrd";
						always = false;
					}
					{
						command =
							"${pkgs.ydotool}/bin/ydotoold --socket-path=/run/user/%U/.ydotool_socket --socket-perm=0600 --socket-own %U:%G";
							always = false;
						}
					];
				};

				extraConfig = ''
					input "type:keyboard" {
						xkb_options ctrl:nocaps
						xkb_numlock enable
						repeat_delay 200
						repeat_rate 30
					}
				'';

				#TODO: Figure out which of these we even still need
				extraSessionCommands = ''
					export MOZ_DBUS_REMOTE=1
					export MOZ_WEBRENDER=1
					export MOZ_ENABLE_WAYLAND=1
					export XDG_SESSION_TYPE=wayland
					export XDG_CURRENT_DESKTOP=sway
					export NIXOS_OZONE_WL=1
					export NIXOS_OZONE_PLATFORM=wayland;
					export QT_QPA_PLATFORM=wayland
					export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

					export SDL_VIDEODRIVER=wayland
					export _JAVA_AWT_WM_NONREPARENTING=1
					export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
					export LIBVA_DRIVER_NAME=iHD
				'';

				wrapperFeatures = {
					gtk = true;
					base = true;
				};

				systemd.enable = true;
				swaynag.enable = true;
			};

		programs.swaylock.enable = true;

		services = {
			swayidle = {
				enable = true;

				timeouts = [
					{
						timeout = 600;
						command = "${pkgs.swaylock}/bin/swaylock -fFe -c000000";
					}
				];

				events = [
					{
						event = "before-sleep";
						command = "${pkgs.swaylock}/bin/swaylock -fFe -c000000";
					}
				];
			};

			mako = { 
				enable = true;
				output = "eDP-1";
				actions = true;
				anchor = "top-right";
				borderRadius = 2;
				borderSize = 1;
				height = 1000;
				icons = true;
				# I know better than you, notification sender.
				ignoreTimeout = true;
				defaultTimeout = 10;
				margin = "4,26";
				markup = true;
				maxVisible = -1;
				padding = "20,16";
				width = 440;
			};
		};

		home.packages = [
			pkgs.autotiling
			pkgs.gammastep
			pkgs.grim
			pkgs.qt5.qtwayland
			pkgs.remontoire
			pkgs.sirula
			pkgs.slurp
			pkgs.sov
			pkgs.sway-contrib.grimshot
			pkgs.swaybg
			pkgs.swayidle
			pkgs.swayr
			pkgs.wayvnc
			pkgs.wev
			pkgs.wl-clipboard
			pkgs.wlr-randr
			pkgs.wob
			pkgs.wofi
			pkgs.ydotool
		];
	};
}

