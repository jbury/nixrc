{ config, lib, jbury-lib, ... }:

let
	inherit (lib) mkDefault mkIf;
	inherit (jbury-lib) mkBoolOpt;

	cfg = config.jbury.nixrc.hostModules.managedNetwork;
in {
	options.jbury.nixrc.hostModules.managedNetwork = {
		enable = mkBoolOpt true;
	};

	config = {
		networking = mkIf cfg.enable {
			useDHCP     = true;
			enableIPv6  = true;
			nameservers = [];
		};
	};
}
