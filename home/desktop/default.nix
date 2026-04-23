{ homeSettings, config, lib, pkgs, ... }:

let
	inherit (lib) mkIf;
in {
	imports = [
		./wayland
	];

	config = mkIf homeSettings.hasDesktop { 
		jbury.nixrc.home.modules.desktop = {
			wayland.enable = true;
		};

		home = {
			packages = [
				pkgs.brightnessctl
				pkgs.playerctl
				pkgs.gparted
				pkgs.feh
				pkgs.keepassxc
				pkgs.xclip
				pkgs.xdg-utils
				pkgs.optipng # I take a _lot_ of screenshots, so making them small is nice
			];

			shellAliases = {
				y = "xclip -selection clipboard -in";
				p = "xclip -selection clipboard -out";
			};

			sessionVariables = {
				XDG_SCREENSHOTS_DIR = "${homeSettings.homeDirectory}/screenshots";
			};
		};
	};
}

