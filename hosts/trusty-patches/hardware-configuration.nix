{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/95ca9aee-4b23-4d29-ada3-4b403e841df4";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/A005-6FC6";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/ecca48c6-6c9d-4afe-820a-a333e4470f00";
      fsType = "ext4";
    };

  fileSystems."/workspace" =
    { device = "/dev/disk/by-uuid/c81658d0-619b-4438-92f8-8ea5f47a0994";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/6baa910c-71dc-4ab1-8461-6c4ad74f800b"; }
    ];

  services.xserver = {
    libinput.enable = true;
    xrandrHeads = [
      { output = "EDP-1"; primary = true; } # eDP-1 connected primary 1920x1200+0+0 (normal left inverted right x axis y axis) 336mm x 210mm 1920x1200     59.95*+  59.88    47.96
      { output = "DP-3-1"; } # DP-3-2 connected 1920x1080+1920+0 (normal left inverted right x axis y axis) 531mm x 299mm 1920x1080     60.00*+ 144.00   119.98    99.93    84.90    50.00    59.94
      { output = "DP-3-3"; } # DP-3-3 connected 3440x1440+3840+0 (normal left inverted right x axis y axis) 819mm x 346mm 3440x1440     59.97*+  99.98    84.96    29.99
    ];

  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  networking.networkmanager.enable = true;
  #networking.interfaces.enp0s13f0u4u4.useDHCP = lib.mkDefault true;
  #networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  ## ssh is related to networking, which is close enough to hardware for me.
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}


