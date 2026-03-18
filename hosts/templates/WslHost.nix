{ inputs, config, lib, jbury-lib, ... }:

let
	inherit (lib) mkForce;
	inherit (lib.types) str;
	inherit (jbury-lib) mkOptDef mkBoolOptDef;

	cfg          = config.jbury.nixrc.hosts.templates.wslHost;
	hostSettings = config.jbury.nixrc.hostSettings;

in {
	imports = [
		../.
		inputs.nixos-wsl.nixosModules.default
	];

	options.jbury.nixrc.hosts.templates.wslHost = {
		userName = mkOptDef str hostSettings.userName;
		hostname = mkOptDef str hostSettings.hostname;

		interop.enable = mkBoolOptDef false;
	};

	config = {
		# WSL support for Linux GUI apps isn't great, so to be safe I just disable all my desktop modules
		jbury.nixrc.hostSettings.hasDesktop = mkForce false;

		system.stateVersion = hostSettings.stateVersion;

		wsl = {
			enable = true;

			defaultUser = cfg.userName;
			wslConf     = {
				interop = {
					enabled           = cfg.interop.enable;
					appendWindowsPath = cfg.interop.enable;
				};

				network = {
					hostname      = cfg.hostname;
					generateHosts = false;
				};
			};
		};
	};
}
