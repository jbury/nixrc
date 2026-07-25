{ config, jbury-lib, ... }:

let
	inherit (jbury-lib) mkBoolOptDef;

	cfg          = config.jbury.nixrc.hosts.templates.nixosHost;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	imports = [
		../.
	];

	options.jbury.nixrc.hosts.templates.nixosHost = {
		docker        = mkBoolOptDef true;
		manageNetwork = mkBoolOptDef true;
		manageBoot    = mkBoolOptDef true;
		manageUsers   = mkBoolOptDef true;
	};

	config = {
		jbury.nixrc.hosts.modules = {
			docker.enable         = cfg.docker;
			managedNetwork.enable = cfg.manageNetwork;
			managedBoot.enable    = cfg.manageBoot;
			managedUsers.enable   = cfg.manageUsers;
		};

		system.stateVersion = hostSettings.stateVersion;
	};
}
