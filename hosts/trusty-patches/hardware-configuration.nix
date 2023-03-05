{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

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


  ### Laptop hardware
  # Just the touchpad for now
  services.xserver = {
    libinput.enable = true;
  };


  ### Boot memes

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };


  ### Disks n' such
  # disk/by-uuid is good enough for me.

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


  ### Monitor Layout
  # Note that autorandr is functionally a manager of xrandr, while arandr is a GUI tool that lets you
  # make a visual layout of your monitors, and then generate the corresponding xrandr config file
  #
  # profiles[*].fingerprint found via `autorandr --fingerprint`
  # profiles[*].config generated via arandr

  services.autorandr = {
    enable = true;
    defaultTarget = "multi";
    profiles = {
      "multi" = {
        fingerprint = {
          DP-3-2 = "00ffffffffffff000469a424010101011d180104a5351e783a9de5a654549f260d5054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500132b2100001e000000fd0032961ea021000a202020202020000000fc0056473234380a20202020202020000000ff0045374c4d51533039343734340a01b1020318f14b900504030201111213141f2309070783010000023a801871382d40582c4500132b2100001e8a4d80a070382c4030203500132b2100001afe5b80a07038354030203500132b2100001a866f80a07038404030203500132b2100001afc7e80887038124018203500132b2100001e0000000000000000000000000073";
          DP-3-3 = "00ffffffffffff0006b35435a6070200181e010380522378ee62f5aa524ca3260f5054bfcf80d1c0b30095008180814081c0714f0101e77c70a0d0a0295020303a00335a3100001a9f3d70a0d0a0155030203a00335a3100001a000000fd0030641e9737000a202020202020000000fc00415355532056473335560a20200193020342f151010304131f120211900f0e1d1e05144b4c230907078301000067030c001000184267d85dc401788000681a000001013064e6e305c001e606070160551d1ab370a0d0a03b5020303a00335a3100001a4ed470a0d0a0465030403a00335a3100001a3041b8a060a029503020b804335a3100001a0000000000000002";
          eDP-1 = "00ffffffffffff0030e4b30600000000001f0104a522157806a205a65449a2250e505400000001010101010101010101010101010101283c80a070b023403020360050d21000001a203080a070b023403020360050d21000001a000000fe00344457564a803135365755310a0000000000024131b2001100000a010a202000ae";
        };
	config = {
	  eDP-1 = {
            enable = true;
            primary = true;
	    position = "3440x1080";
	    mode = "1920x1200";
	    rate = "59.95";
	  };
	  DP-3-2 = {
	    enable = true;
	    mode = "1920x1080";
	    position = "3440x0";
	  };
	  DP-3-3 = {
	    enable = true;
	    mode = "3440x1440";
	    position = "0x437";
	  };
        };
      }; #End of multi profile
    };
  };

}


