{ lib, config, modulesPath, inputs, ... }:

let inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # fwupd needed for firmware updates
  services.fwupd.enable = true;

  services.thermald.enable = true;

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

      ### Monitor Layout
  # Note that autorandr is functionally a manager of xrandr, while arandr is a GUI tool that lets you
  # make a visual layout of your monitors, and then generate the corresponding xrandr config file
  #
  # profiles[*].fingerprint found via `autorandr --fingerprint`
  # profiles[*].config generated via arandr

  services.autorandr = {
    defaultTarget = "multi";
    profiles = {
      "multi" = {
        fingerprint = {
          # 4k
          DP-11 =
            "00ffffffffffff001e6d0e78f9e602000522010380462778ea5a15ad523faf250e5054210900d1c06140454081c001010101010101014dd000a0f0703e8030203500b9882100001a000000fd0030f01efff8000a202020202020000000fc004c4720554c545241474541522b000000ff003430354e545747354c3230310a03ebf00270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009e02035b71230f0707834f00004d7661605f5e5d3f1f12100403016d030c001000b8442000600102036dd85dc4017880630030f0c3643fe30f0700e2006ae305c000e6060501734f01721a0000030330f000a073014f02f000000000a36600a0f0701f8030203500b9882100001a6fc200a0a0a0555030203500b9882100001a98701279030001000c3a1b500f000f7008";
          # Ultrawide
          DP-10 =
            "00ffffffffffff0006b35435a6070200181e0104b55223783b62f5aa524ca3260f5054bfcf00d1c0b30095008180814081c0714f01014ed470a0d0a0465030203a00335a3100001ae77c70a0d0a0295020303a00335a3100001a000000fd003064979737010a202020202020000000fc00415355532056473335560a2020019f02032ef14d010304131f120211900f0e1d1e2309070783010000e200d565030c001000e305c000e606070160551d1ab370a0d0a03b5020303a00335a3100001a539d70a0d0a0345030203a00335a3100001a3041b8a060a029503020b804335a3100001a0000000000000000000000000000000000000000000000000000002b";
          # Laptop
          eDP-1 =
            "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "1184x1440";
            mode = "2256x1504";
          };
          # Ultrawide
          DP-10 = {
            enable = true;
            position = "0x0";
            mode = "3440x1440";
          };
          # 4k
          DP-11 = {
            enable = true;
            position = "3440x720";
            mode = "3840x2160";
          };
        };
      }; # End of multi profile

      "single" = {
        fingerprint = {
          eDP-1 =
            "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2256x1504";
          };
        };
      }; # End of single profile
    };
  };

}
