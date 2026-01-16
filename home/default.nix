{ jbury-lib, config, ... }: {

let
	inherit (jbury-lib) mkOptDef;

	cfg          = config.jbury.nixrc.homeSettings;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	options.jbury.nixrc.homeSettings = {
		name     = mkOptDef str hostSettings.name;
		email    = mkOptDef str hostSettings.email;
		userName = mkOptDef str hostSettings.userName;
		homedir  = mkOptDef str "/home/${hostSettings.userName}";

		stateVersion = mkOptDef str hostSettings.stateVersion;
	};

	config = {
		home-manager = {
			useGlobalPkgs   = true;
			useUserPackages = true;
			stateVersion    = cfg.stateVersion;

			users.${cfg.userName} = import ./modules;
		};
	};
}
