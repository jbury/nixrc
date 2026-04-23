{ homeSettings, config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.desktop.wayland;
in {
	imports = [
		
	];

	options.jbury.nixrc.home.modules.desktop.wayland = {
		enable = mkEnableOption "wayland";
	};

	config = mkIf cfg.enable {
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

		home = {
			#TODO: I have no idea which, if any, of these are even needed anymore.  This is all pre-refactor.
			packages = [
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

			sessionVariables = {
			};
		};
	};
}

