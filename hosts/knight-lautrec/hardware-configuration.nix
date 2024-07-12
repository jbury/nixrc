{ lib, config, modulesPath, inputs, ... }:

let inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # fwupd needed for firmware updates
  services.fwupd.enable = true;

  networking.networkmanager.enable = true;
  networking.useDHCP = mkDefault true;

  ## ssh is related to networking, which is close enough to hardware for me.
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = mkDefault "powersave";

  hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

  ### Laptop hardware
  # Just the touchpad for now
  services.libinput.enable = true;

  ### Boot memes

  boot = {
    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  ### Disks n' such
  # disk/by-uuid is good enough for me.

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/28a405a9-c75f-4baa-8cb5-3ea3e159f2ad";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-e06ea226-c7cf-4486-87d0-ad0fef7832cc".device = "/dev/disk/by-uuid/e06ea226-c7cf-4486-87d0-ad0fef7832cc";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/ED14-07E8";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    swapDevices = [ ];
}
