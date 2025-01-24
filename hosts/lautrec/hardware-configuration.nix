{ lib, config, modulesPath, inputs, ... }:

let inherit (lib) mkDefault mkForce;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # fwupd needed for firmware updates
  services.fwupd.enable = true;

  networking.networkmanager.enable = true;
  networking.useDHCP = mkDefault true;

  systemd.services.NetworkManager-wait-online.enable = mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = mkForce false;

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
        [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "ahci" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "amdgpu" "iwlwifi" "k10temp" "kvm-amd" ];
    extraModulePackages = [ ];
  };

  ### Disks n' such
  # disk/by-uuid is good enough for me.

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1e26657b-742c-4a8c-a681-def6a132be9f";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/8ea5b5eb-3dc9-4406-a061-f1d5dcb7950f";

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    swapDevices = [ ];
}
