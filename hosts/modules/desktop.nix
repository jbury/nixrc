{ config, lib, ... }:
 let
	inherit (lib) mkIf mkForce;

	hostSettings = config.jbury.nixrc.hostSettings;
in {
	config = mkIf hostSettings.hasDesktop {
		security = {
			# Wayland needs strict security policy stuff
			polkit.enable         = true;
			pam.services.swaylock = {};
		};

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

