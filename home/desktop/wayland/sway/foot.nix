{ config, lib, pkgs, ... }:

let
	inherit (lib) mkIf mkForce;

	cfg = config.jbury.nixrc.home.modules.desktop.wayland.sway;
in {

	config = mkIf cfg.enable {
		programs.foot = {
			enable = true;
			settings = {
				main = {
					term = "xterm-256color";
					font = "Iosevka Term:size=12";

					dpi-aware = mkForce "yes";
				};
				bell = {
					urgent = "no";
					notify = "no";
					visual = "no";
				};
				scrollback = {
					lines = 20000;
				};
			};
		};
	};
}
