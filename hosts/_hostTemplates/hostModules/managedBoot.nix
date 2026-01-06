{ config, lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkEnableOption mkIf;

	cfg = config.jbury.nixrc.hostModules.managedBoot;
in {
	options.jbury.nixrc.hostModules.managedBoot = {
		enable = mkEnableOption "Nixos-managed boot";
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
