{ homeSettings, config, lib, pkgs, ... }:

let
	inherit (lib) mkIf;
in {
	imports = [
		./browsers
		./wayland
		./term
	];

	config = mkIf homeSettings.hasDesktop { 
		jbury.nixrc.home.modules.desktop = {
			wayland.enable = true;
		};

		home = {
			packages = [
				pkgs.brightnessctl
				pkgs.discord
				pkgs.feh
				pkgs.gparted
				pkgs.keepassxc
				pkgs.optipng # I take a _lot_ of screenshots, so making them small is nice
				pkgs.playerctl
				pkgs.rclone
				pkgs.signal-desktop
				pkgs.slack
				pkgs.xclip
				pkgs.xdg-utils
			];

			shellAliases = {
				y = "xclip -selection clipboard -in";
				p = "xclip -selection clipboard -out";

				memesdown = "rclone sync google-drive:/memes/ ~/Pictures/memes/";
				kpdown = "rclone sync --interactive google-drive:/Adult\\ Stuff/Personal.kdbx ~/";
			};

			sessionVariables = {
				XDG_DESKTOP_DIR     = "${homeSettings.homeDirectory}/Desktop";
				XDG_SCREENSHOTS_DIR = "${homeSettings.homeDirectory}/screenshots";
			};
		};
	};
}

