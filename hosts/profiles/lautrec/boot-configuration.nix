{ ... }:

{

	boot = {
		initrd = {
			luks.devices."cryptroot".device = "/dev/disk/by-uuid/8ea5b5eb-3dc9-4406-a061-f1d5dcb7950f";

			availableKernelModules = [
				"nvme"
				"xhci_pci"
				"thunderbolt"
				"usb_storage"
				"ahci"
				"usbhid"
				"sd_mod"
			];
			kernelModules = [ ];
		};

		kernelModules = [ "amdgpu" "iwlwifi" "k10temp" "kvm-amd" ];
		extraModulePackages = [ ];
	};
}
