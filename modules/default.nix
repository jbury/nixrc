{ jbury-lib, lib, config, ... }:

let
	inherit (lib.types) str;
	inherit (jbury-lib) mkOptDef;

	cfg          = config.jbury.nixrc.homeSettings;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	imports = [
		./editors
	];

	options.jbury.nixrc.homeSettings = {
		stateVersion = mkOptDef str hostSettings.stateVersion;
	};

	config = {
		home-manager = {
			useGlobalPkgs     = true;
			useUserPackages   = true;

			users.${hostSettings.userName} = {
				home.username      = ${hostSettings.userName};
				home.homeDirectory = "/home/${hostSettings.userName};
				home.stateVersion  = cfg.stateVersion;
			};
		};
	};
}
