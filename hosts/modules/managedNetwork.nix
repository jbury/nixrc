{ config, lib, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.hosts.modules.managedNetwork;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	options.jbury.nixrc.hosts.modules.managedNetwork = {
		enable = mkEnableOption "Nixos-managed network";
	};

	config = {
		networking = mkIf cfg.enable {
      hostName    = hostSettings.hostname;
      useDHCP     = false;
			enableIPv6  = true;
			nameservers = [];

      networkmanager.enable = true;
		};

		programs.ssh.startAgent          = true;
		services.openssh.startWhenNeeded = true;
	};
}
