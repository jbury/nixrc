## This is the home-manager configuration module for a user (jbury by default)
{ jbury-lib, lib, config, ... }:

let
	inherit (lib.types) str;
	inherit (jbury-lib) mkOpt mkOptDef mkBoolOpt;

	cfg = config.jbury.nixrc.homeSettings;
in {
	imports = [
		./editors
		./gitKeys.nix
	];

	options.jbury.nixrc.homeSettings = {
		userName   = mkOptDef str "jbury";
		homedir    = mkOptDef str "/home/${cfg.userName}";
		hostname   = mkOpt str;
		hasDesktop = mkBoolOpt;

		stateVersion = mkOpt str;
	};

	config = {
		home = {
			username      = cfg.userName;
			homeDirectory = cfg.homedir;
			stateVersion  = cfg.stateVersion;
		};

		programs.home-manager.enable = true;
	};
}
