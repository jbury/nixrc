{ config, jbury-lib, ... }:

let
	inherit (jbury-lib) mkBoolOptDef;

	cfg          = config.jbury.nixrc.hosts.templates.nixosHost;
	hostModules  = config.jbury.nixrc.hosts.modules;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	imports = [
		../
	];

	options.jbury.nixrc.hosts.templates.nixosHost = {
		manageNetwork = mkBoolOptDef true;
		manageBoot    = mkBoolOptDef true;
	};

	config = {
		hostModules.managedNetwork.enable = cfg.manageNetwork;
		hostModules.managedBoot.enable    = cfg.manageBoot;

		system.stateVersion = hostSettings.stateVersion;
	};
}
