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
				package = (pkgs.iosevka-bin.override { variant = "Etoile"; });
				name    = "Iosevka Etoile";
			};
			sansSerif = {
				package = (pkgs.iosevka-bin.override { variant = "Aile"; });
				name    = "Iosevka Aile";
			};
			monospace = {
				package = (pkgs.iosevka-bin.override { variant = "SGr-IosevkaFixed"; });
				name    = "Iosevka Term";
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
