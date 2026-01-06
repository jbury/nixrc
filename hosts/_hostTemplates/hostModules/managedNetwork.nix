{ config, lib, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.hostModules.managedNetwork;
in {
	options.jbury.nixrc.hostModules.managedNetwork = {
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
