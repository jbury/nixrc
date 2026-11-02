{ config, pkgs, lib, ... }:

let
	inherit (lib) mkIf;

	hostSettings = config.jbury.nixrc.hostSettings;

	schemeName = "tokyodark-terminal.yaml";
in {
	config.stylix = {
		enable = true;

		polarity = "dark";

		base16Scheme = "${pkgs.base16-schemes}/share/themes/${schemeName}";

		fonts = {
			serif = {
				package = pkgs.nerd-fonts.iosevka;
				name    = "Iosevka Etoile Nerd Font";
			};
			sansSerif = {
				package = pkgs.nerd-fonts.iosevka;
				name    = "Iosevka Aile Nerd Font";
			};
			monospace = {
				package = pkgs.nerd-fonts.iosevka;
				name    = "Iosevka Mono Nerd Font";
			};
			emoji = {
				package = pkgs.noto-fonts-color-emoji;
				name    = "Noto Color Emoji";
			};

			sizes = {
				desktop = 12;
				applications = 12;
			};
		};

		image = mkIf hostSettings.hasDesktop ./desktop/wallpaper.png;
	};
}
