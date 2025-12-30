{ config, lib, jbury-lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkIf;
	inherit (jbury-lib) mkBoolOpt;

	cfg = config.jbury.nixrc.hostModules.managedBoot;
in {
	options.jbury.nixrc.hostModules.managedBoot = {
		enable = mkBoolOpt true;
	};

	config = {
		boot = mkIf cfg.enable {
			kernelPackages = pkgs.linuxPackages_latest;

			loader = {
				systemd-boot = {
					enable = mkDefault true;
					configurationLimit = 5;
					editor = false;
				};

				efi = {
					canTouchEfiVariables = true;
				};
			};
		};
	};
}
