{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
    inputs.nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
    inputs.nixos-hardware.nixosModules.common-pc-laptop-hdd
  ];

  boot = {
    initrd.availableKernelModules = [
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
    initrd.kernelModules = [ ];
    blacklistedKernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with pkgs.linuxPackages_latest; [ v4l2loopback ];
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
      options nfs nfs4_disable_idmapping=0
    '';
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva vaapiIntel ];
    };
    pulseaudio.support32Bit = true;
    steam-hardware.enable = true;
    bluetooth.enable = true;
    pulseaudio = {
      enable = false;

      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };

  # CPU
  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.intel.updateMicrocode = true;

  # Storage
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B0FC-C26E";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/449742dc-6c34-42d8-98fb-1f6f6ce5dfd0"; }];
}
