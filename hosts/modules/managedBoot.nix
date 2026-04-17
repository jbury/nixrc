{ config, lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkEnableOption mkIf;

	cfg = config.jbury.nixrc.hosts.modules.managedBoot;
in {
	options.jbury.nixrc.hosts.modules.managedBoot = {
		enable = mkEnableOption "Nixos-managed boot";
	};

	config = mkIf cfg.enable {
		boot = {
			kernelPackages = pkgs.linuxPackages_latest;

			loader = {
				systemd-boot = {
					enable = mkDefault true;
					configurationLimit = 5;
				};

				efi = {
					canTouchEfiVariables = true;
					efiSysMountPoint = "/boot";
				};
			};
		};

		## System security configs
		boot = {
			tmp = {
				# Mounting /tmp in RAM forces temp files to get cleaned on reboot
				useTmpfs = lib.mkDefault true;
				# If we aren't using tmpfs, enable the purge-on-boot feature to 
				# enforce volatility on /tmp
				cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
			};

			# Fix a security hole left around for backwards compatibility.  See
			# nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
			loader.systemd-boot.editor = false;

			# The Magic SysRq key is a key combo that lets users connected to the
			# system console of a Linux kernel to perform some low-level commands.
			kernel.sysctl."kernel.sysrq" = 0;
		};

		security = {
			# Kernel can't be replaced without a reboot.
			protectKernelImage = true;

			# Declarative acceptance of terms?  yes pls.
			acme.acceptTerms = true;

			sudo.extraRules = [
				{
					groups = [ "wheel" ];
					commands = [ "ALL" ];
				}

				{
					groups = [ "wheel" ];
					commands = [{
						command = "/run/current-system/sw/bin/shutdown";
						options = [ "NOPASSWD" ];
					}];
				}
			];
		};
	};
}
