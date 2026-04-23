{ config, lib, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.hosts.modules.managedNetwork;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	options.jbury.nixrc.hosts.modules.managedNetwork = {
		enable = mkEnableOption "Nixos-managed network";
	};

	config = mkIf cfg.enable {
		networking = {
      hostName    = hostSettings.hostname;
      useDHCP     = false;
			enableIPv6  = true;
			nameservers = [];

      networkmanager.enable = true;
		};

		programs.ssh = {
			startAgent = true;
			# This was barely a realistic concern in 2016,  but I'm Greek, not Roamin.
			extraConfig = ''
				Host *
					UseRoaming no
			'';
		};

		services.openssh.startWhenNeeded = true;
	};
}
