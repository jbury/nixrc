{ lib, ... }:

let
	inherit (lib)       findFirst pathExists removePrefix;
	inherit (lib.types) path str;
	inherit (lib.my)    mkOpt;
in {
	# Defaults and options that I'll set at the per-host level if needed
	options.hostModules.hostSettings = {
		userName = mkOpt str "jbury";
		hostName = mkOpt str config.networking.hostName;
		email    = mkOpt str "jasondougbury@gmail.com";

		dotfilesDir = mkOpt path (removePrefix "/mnt"
			(findFirst pathExists (toString ../../../.) [ "/etc/nixos", "~/.nixrc" ];

		home.stateVersion = mkOpt str "25.05";
	};
}
