{ config, lib, pkgs, ... }:

let
	inherit (lib) mkDefault;
	inherit (lib.types) str;
	inherit (lib.my) mkBoolOpt mkOpt;

	cfg     = config.hostModules.home-manager;
	hostCfg = config.hostModules.hostSettings;
in {
	options.hostModules.home-manager = {
		manageUser   = mkBoolOpt false;
		userName     = mkOpt str hostCfg.userName;
		stateVersion = mkOpt str hostCfg.home.stateVersion;
	};

	config = {
		#TODO: Ensure these are set for everyone, probably by splitting this out into
		# a home-modules file or some such nonsense.
		environment.variables.DOTFILES     = config.dotfiles.dir;
		environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

		home-manager = {
			useGlobalPkgs = true;
	
			# I don't currently have any use for nixos-rebuild build-vm, so /etc/profiles isn't needed
			useUserPackages = false;

			# TODO Move under some user-management module
			# options.nix and xdg.nix contain a fair bit of other stuff too. Need to figure out
			# what is automagically done by nixos-wsl so I know what the optional user-management needs
			# vs. what every system needs.
			users.${cfg.userName} = {
				username      = cfg.userName;
				homeDirectory = "/home/${cfg.userName}";
				stateVersion  = cfg.stateVersion;
				activation    = import ./home-activation.nix { inherit config pkgs lib; };
			};
		};
	};
}
