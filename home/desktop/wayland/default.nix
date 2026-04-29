{ homeSettings, config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.desktop.wayland;
in {
	imports = [
		./sway
	];

	options.jbury.nixrc.home.modules.desktop.wayland = {
		enable = mkEnableOption "wayland";
	};

	config = mkIf cfg.enable {
		jbury.nixrc.home.modules.desktop.wayland.sway.enable = true;

		xdg.portal = {
			enable = true;

			extraPortals = [
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-wlr
			];

			xdgOpenUsePortal = true;

			# Lazy lexicographical order portal selection til it bites me which might be right away depending on gtk's willingness to share a screen
			config.common.default = "*";
		};
	};
}

