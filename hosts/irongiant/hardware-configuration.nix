{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
    ];
    extraModprobeConfig = ''
      options nfs nfs4_disable_idmapping=0
    '';
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # CPU
  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "performance";

  # Storage
  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/14c3182f-f307-466a-8de3-b750e11ed995";
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/074A-FDB3";
    fsType = "vfat";
  };

  fileSystems."/mnt/nas" = {
    device = "192.168.86.34:/volume1/homes";
    fsType = "nfs";
    options = [ "nfsvers=4.1" ];
  };

  swapDevices = [{
    device = "/swapfile";
    size = 10240;
  }];
}
