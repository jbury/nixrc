{ config, jbury-lib, ... }:

let
	inherit (jbury-lib) mkBoolOpt;

	cfg          = config.jbury.nixrc.hosts.templates.nixosHost;
	hostModules  = config.jbury.nixrc.hosts.modules;
in {
	imports = [
		./
		../modules/managedNetwork.nix
		../modules/managedBoot.nix
	];

	options.jbury.nixrc.hosts.templates.nixosHost = {
		hasDesktop    = mkBoolOpt true;
		manageNetwork = mkBoolOpt true;
		manageBoot    = mkBoolOpt true;
	};

	config = {
		hostModules.managedNetwork.enable = cfg.manageNetwork;
		hostModules.managedBoot.enable    = cfg.manageBoot;
	};
}
