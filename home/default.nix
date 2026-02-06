{ jbury-lib, lib, config, ... }:

let
	inherit (lib.types) str;
	inherit (jbury-lib) mkOptDef mkOpt;

	hostSettings = config.jbury.nixrc.hostSettings;
	cfg = config.jbury.nixrc.homeSettings;
in {
	imports = [
		./editors
	];

	options.jbury.nixrc.homeSettings = {
		userName = mkOptDef str "jbury";
		hostname = mkOptDef str hostSettings.hostname;

		stateVersion = mkOptDef str hostSettings.stateVersion;
	};

	config = {
		home-manager = {
			useGlobalPkgs     = true;
			useUserPackages   = true;

			users.${cfg.userName} = {
				home.username      = cfg.userName;
				home.homeDirectory = "/home/${cfg.userName}";
				home.stateVersion  = cfg.stateVersion;
			};
		};
	};
}
