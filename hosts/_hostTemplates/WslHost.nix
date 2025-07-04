{ config, lib, ... }:
# Default settings to use for all WSL hosts, including mapping my hostSettings to
# the relevant nixos-wsl config options.

let
	inherit (lib.types) str;
	inherit (lib.my) mkOpt;

	cfg = config.wslHost;
	hostcfg = config.hostSettings;
in {
	imports = [
		nixos-wsl.nixosModules.default
		./NixosHost.nix
	];

	options.wslHost = {
		userName     = mkOpt str hostcfg.userName;
		hostName = mkOpt str hostcfg.hostName;

		interop.enable = mkBoolOpt true;
	};

	config = {
		nixosHost = {
			hasDesktop    = false;
			manageBoot    = false;
			manageNetwork = false;
		};

		wsl = {
			enable = true;
			defaultUser = cfg.userName;
			wslConfg = {
				interop.enabled           = cfg.interop.enable;
				interop.appendWindowsPath = cfg.interop.enable;
				network.hostname          = cfg.hostName;
			};
		};
	};
}
