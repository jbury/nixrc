{ ... }:
  ### Disks n' such

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/8ea5b5eb-3dc9-4406-a061-f1d5dcb7950f";

  # disk/by-uuid is good enough for me.

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [ ];
}
