{ inputs, config, lib, jbury-lib, ... }:
# Default settings to use for all WSL hosts, including mapping my hostcfg to
# the relevant nixos-wsl config options.

let
	inherit (lib.types) str;
	inherit (jbury-lib) mkOpt mkBoolOpt;

	cfg          = config.jbury.nixrc.hosts.templates.wslHost;
	hostSettings = config.jbury.nixrc.hostSettings;
in {
	imports = [
		inputs.nixos-wsl.nixosModules.default
		./
	];

	options.jbury.nixrc.hosts.templates.wslHost = {
		userName = mkOpt str hostSettings.userName;
		hostname = mkOpt str hostSettings.hostname;

		interop.enable = mkBoolOpt true;
	};

	config = {
		jbury.nixrc.hostSettings = {
			# This won't work because this option isn't set in the default.nix, but I don't think it _SHOULD_ be.  But I want it at some top level layer or something?  idk where to put this option tbqh.
			hasDesktop    = false;
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
