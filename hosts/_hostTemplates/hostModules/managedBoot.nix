{ config, lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkIf;
	inherit (lib.my) mkBoolOpt;

	cfg = config.hostModules.managedBoot;
in {
	options.hostModules.managedBoot = {
		enable = mkBoolOpt true;
	};

	config = {
		boot = mkIf cfg.enable {
			kernelPackages = mkDefault pkgs.linuxPackages_latest;

			loader = {
				systemd-boot = {
					enable = mkDefault true;
					configurationLimit = 5;
					editor = false;
				};

				efi = {
					canTouchEfiVariables = mkDefault true;
					efiSysMountPount = "/boot";
				};
			};
		};
	};
}
