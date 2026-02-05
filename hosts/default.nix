{ inputs, lib, jbury-lib, config, pkgs, ... }:

let
	inherit (lib)       mkDefault findFirst pathExists removePrefix;
	inherit (lib.types) path str;
	inherit (jbury-lib) mkBoolOptDef mkOptDef mkOpt;

	cfg = config.jbury.nixrc.hostSettings;
in {
	imports = [
		./modules
	];

	# Top-level config options that dictate most per-host defaults
	options.jbury.nixrc.hostSettings = {
		userName = mkOptDef str "jbury";
		hostname = mkOptDef str config.networking.hostname;

		# Single set point for both system.stateVersion and home-manager.stateVersion
		stateVersion = mkOpt str;

		timeZone = mkOptDef str "America/Los_Angeles";

		hasDesktop = mkBoolOptDef false;


		#TODO: Remove me
		dotfilesDir = mkOptDef path (removePrefix "/mnt" (findFirst pathExists (toString ../../../.) [ "/etc/nixos" "~/.nixrc" ]));
	};

	config = {
		# Packages for _every_ user to have access to - e.g. root, or steam, or whatever
		environment.systemPackages = with pkgs; [
			bat
			bind
			cacert
			cached-nix-shell
			curl
			datamash
			envsubst
			eza
			fd
			file
			git
			gnumake
			gnupg
			gum
			jq
			lsof
			nh
			openssl
			ripgrep
			tldr
			tree
			unzip
			vim
			wget
			yq-go
		];

		time.timeZone = cfg.timeZone;

		i18n = {
			defaultLocale = mkDefault "en_US.UTF-8";

			extraLocaleSettings = {
				LC_ADDRESS        = "en_US.UTF-8";
				LC_IDENTIFICATION = "en_US.UTF-8";
				LC_MEASUREMENT    = "en_US.UTF-8";
				LC_MONETARY       = "en_US.UTF-8";
				LC_NAME           = "en_US.UTF-8";
				LC_NUMERIC        = "en_US.UTF-8";
				LC_PAPER          = "en_US.UTF-8";
				LC_TELEPHONE      = "en_US.UTF-8";
				LC_TIME           = "en_US.UTF-8";
			};
		};
	};
}
