{ inputs, config, lib, jbury-lib, ... }:

let
	inherit (lib) mkForce mkDefault;
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

		docker = mkBoolOptDef true;
	};

	config = {
		# WSL support for Linux GUI apps isn't great, so to be safe I just disable all my desktop modules
		jbury.nixrc = {
			hostSettings.hasDesktop = mkForce false;

			hosts.modules.docker.enable = cfg.docker;
		};

		system.stateVersion = hostSettings.stateVersion;

		# I don't bother generating a hardware-configuration.nix for nixos-wsl profiles, which is where this should _usually_ be defined, so just set it at the wsl template level instead.
		nixpkgs.hostPlatform = mkDefault "x86_64-linux";

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
				};
			};
		};
	};
}
