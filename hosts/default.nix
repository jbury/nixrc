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
		userName   = mkOptDef str "jbury";
		email      = mkOptDef str "2317537+jbury@users.noreply.github.com";
		hostname   = mkOptDef str config.networking.hostname;
		hasDesktop = mkBoolOptDef false;

		# Single set point for both system.stateVersion and home-manager.stateVersion
		stateVersion = mkOpt str;

		timeZone = mkOptDef str "America/Los_Angeles";
	};

	config = {
		nix = {
			settings = {
				auto-optimise-store      = true;
				download-buffer-size     = 524288000; # 500 MiB
				experimental-features    = ["nix-command" "flakes"];
				use-xdg-base-directories = true;
				trusted-users            = [ "@wheel" "root" ];
				ssl-cert-file            = "/etc/ssl/certs/ca-bundle.crt";
			};

			gc = {
				automatic  = true;
				dates      = "weekly";
				persistent = true;
			};
		};

		# Packages for _every_ user to have access to - e.g. root, or steam, or whatever
		environment.systemPackages = with pkgs; [
			bind
			cacert
			cached-nix-shell
			curl
			envsubst
			git
			gnumake
			gnupg
			gum
			jq
			lsof
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
