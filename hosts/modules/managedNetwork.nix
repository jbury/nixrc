{ config, lib, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.hosts.modules.managedNetwork;
in {
	options.jbury.nixrc.hosts.modules.managedNetwork = {
		enable = mkEnableOption "Nixos-managed network";
	};

	config = {
		networking = mkIf cfg.enable {
			useDHCP     = true;
			enableIPv6  = true;
			nameservers = [];
		};
	};
}
