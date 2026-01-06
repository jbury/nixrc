{ inputs, config, lib, jbury-lib, ... }:
# Default settings to use for all WSL hosts, including mapping my hostcfg to
# the relevant nixos-wsl config options.

let
	inherit (lib.types) str;
	inherit (jbury-lib) mkOpt mkBoolOpt;

	cfg     = config.jbury.nixrc.hostTemplates.wslHost;
	hostcfg = config.jbury.nixrc.host;
in {
	imports = [
		inputs.nixos-wsl.nixosModules.default
		./NixosHost.nix
	];

	options.jbury.nixrc.hostTemplates.wslHost = {
		userName = mkOpt str hostcfg.userName;
		hostname = mkOpt str hostcfg.hostname;

		interop.enable = mkBoolOpt true;
	};

	config = {
		jbury.nixrc.hostTemplates.nixosHost = {
			hasDesktop    = false;
			manageBoot    = false;
			manageNetwork = false;
		};

		wsl = {
			enable = true;

			defaultUser = cfg.userName;
			wslConf     = {
				interop.enabled           = cfg.interop.enable;
				interop.appendWindowsPath = cfg.interop.enable;
				network.hostname          = cfg.hostname;
			};
		};
	};
}
