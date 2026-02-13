{ jbury-lib, lib, config, ... }:

let
	inherit (lib.types) str;
	inherit (jbury-lib) mkOptDef mkBoolOptDef;

	hostSettings = config.jbury.nixrc.hostSettings;
	cfg          = config.jbury.nixrc.homeSettings;
in {
	imports = [
		./editors
	];

	options.jbury.nixrc.homeSettings = {
		userName   = mkOptDef str "jbury";
		hostname   = mkOptDef str hostSettings.hostname;
		hasDesktop = mkBoolOptDef hostSettings.hasDesktop;

		stateVersion = mkOptDef str hostSettings.stateVersion;
	};

	config = {
		home-manager = {
			useGlobalPkgs = true;

			users.${cfg.userName} = {
				home.username      = cfg.userName;
				home.homeDirectory = "/home/${cfg.userName}";
				home.stateVersion  = cfg.stateVersion;
			};
		};
	};
}
