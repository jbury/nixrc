{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot.initrd.kernelModules = [ "dm-snapshot" "dm-cache-default" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_usb_sdmmc"
    "aesni_intel"
    "cryptd"
  ];

  services.lvm.boot.thin.enable = true;

  boot.blacklistedKernelModules = [ "iTCO_wdt" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

  boot.kernelParams = [
    # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
    #   vulnerabilities for a slight performance boost. Don't copy this blindly!
    #   And especially not for mission critical or server/headless builds
    #   exposed to the world.
    "mitigations=off"
    "i915.mitigations=off"
    "i915.enable_fbc=0"
    "i915.enable_guc=3"
    "i915.modeset=1"
    "nmi_watchdog=0"
  ];

  # Refuse ICMP echo requests on on desktops/laptops; nobody has any business
  # pinging them.
  # boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;

  # Modules
  modules.hardware = {
    audio.enable = true;
    ergodox.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = false;
    sensors.enable = true;
  };

  # CPU
  nix.settings.max-jobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = "performance";
  # Comment out as appropriate
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Storage
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-label/homes";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
  swapDevices = [{ device = "/swapfile"; size = 8192; }];
}
