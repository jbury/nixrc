{ lib, jbury-lib, config, ... }:

let
	inherit (lib)       findFirst pathExists removePrefix;
	inherit (lib.types) path str;
	inherit (jbury-lib) mkOpt;
in {
	imports = [
		./hostModules/managedNetwork.nix
		./hostModules/managedBoot.nix
	];

	# Defaults and options that I'll set at the per-host level if needed
	options.jbury.nixrc.host = {
		userName = mkOpt str "jbury";
		hostname = mkOpt str config.networking.hostname;
		email    = mkOpt str "jasondougbury@gmail.com";
		timeZone = mkOpt str "America/Los_Angeles";

		dotfilesDir = mkOpt path (removePrefix "/mnt" (findFirst pathExists (toString ../../../.) [ "/etc/nixos" "~/.nixrc" ]));

		home.stateVersion = mkOpt str "25.05";
	};
}
