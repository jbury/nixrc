{ inputs, lib, jbury-lib, config, pkgs, ... }:

let
	inherit (lib)       findFirst pathExists removePrefix;
	inherit (lib.types) path str;
	inherit (jbury-lib) mkOpt mkBoolOpt;
in {
	# Defaults and options that I'll set at the per-host level if needed
	options.jbury.nixrc.hostSettings = {
		userName = mkOpt str "jbury";
		hostname = mkOpt str config.networking.hostname;
		email    = mkOpt str "jasondougbury@gmail.com";
		timeZone = mkOpt str "America/Los_Angeles";

		#TODO: Remove me
		dotfilesDir = mkOpt path (removePrefix "/mnt" (findFirst pathExists (toString ../../../.) [ "/etc/nixos" "~/.nixrc" ]));

		home.stateVersion = mkOpt str "25.05";
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

		time.timeZone = hostSettings.timeZone;

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

		system.configurationRevision = mkIf (inputs.self ? inputs.rev) inputs.self.rev	
	};
}
