{ inputs, config, lib, jbury-lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkIf;
	inherit (lib.types) str;
	inherit (jbury-lib) mkBoolOpt mkOpt;

	cfg = config.jbury.nixrc.nixosHost;
in {
	imports = [
		./default.nix
		./hostModules/managedNetwork.nix
		./hostModules/managedBoot.nix
	];

	options.jbury.nixrc.nixosHost = {
		hasDesktop    = mkBoolOpt true;
		manageNetwork = mkBoolOpt true;
		manageBoot    = mkBoolOpt true;

		timeZone = mkOpt str "America/Los_Angeles";
	};

	config = {
		jbury.nixrc.hostModules.managedNetwork.enable = cfg.manageNetwork;
		jbury.nixrc.hostModules.managedBoot.enable    = cfg.manageBoot;

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

		system.configurationRevision = mkIf (inputs.self ? inputs.rev) inputs.self.rev;
	};
}
