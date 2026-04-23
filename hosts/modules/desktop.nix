{ config, lib, ... }:
 let
	inherit (lib) mkIf mkForce;

	hostSettings = config.jbury.nixrc.hostSettings;
in {
	config = mkIf hostSettings.hasDesktop {
		# Wayland needs strict security policy stuff
		security.polkit.enable = true;

		services = {
			xserver.enable = mkForce false;

			udev.extraRules = ''
				KERNEL=="uinput", GROUP="inpu", MODE="0660", OPTIONS+="static_node=uinput"
			'';
		};

		# https://github.com/nix-community/home-manager/blob/0d02ec1d0a05f88ef9e74b516842900c41f0f2fe/modules/misc/xdg-portal.nix#L39
		environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
	};
}

