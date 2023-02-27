{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  kernel = pkgs.linuxPackages_latest;
  # kernel = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.linuxPackages_6_0;
in {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
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
    initrd.kernelModules = [ "i915" ] ++ (if config.modules.hardware.nvidia.enable then [ "nvidia" ] else []);
    blacklistedKernelModules = [ "iTCO_wdt" "nouveau" ];
    kernelPackages = kernel;
    extraModulePackages = with kernel; [ v4l2loopback acpi_call ];
    kernelModules = [ "kvm-intel" "v4l2loopback" "akvcam" ];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
      "i915.mitigations=off"
      "i915.enable_fbc=1"
      "i915.enable_guc=3"
      "i915.modeset=1"
      "mem_sleep_default=deep"
      "nmi_watchdog=0"
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
      options iwlwifi 11n_disable=8 bt_coex_active=1 power_save=0
      options iwlmvm power_scheme=1
      options nfs nfs4_disable_idmapping=0
    '';

    # I guess to stop NVRAM wearout?
    loader.efi.canTouchEfiVariables = false;

    kernel.sysctl = { "fs.inotify.max_user_instances" = 1024; };

    # cool, but sort of worthless with LUKS and Sway
    plymouth.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = if config.modules.hardware.nvidia.enable then [
        (lib.hiPrio pkgs.nvidia-vaapi-driver)
      ] else [
        pkgs.vaapiIntel
        pkgs.vaapiVdpau
        pkgs.libvdpau-va-gl
        pkgs.intel-media-driver
      ];
      extraPackages32 = if config.modules.hardware.nvidia.enable then [
      ] else with pkgs.pkgsi686Linux; [
        libva vaapiIntel
      ];
    };
    # pulseaudio.support32Bit = false;
    steam-hardware.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      settings = { General.Enable = "Source,Sink,Media,Socket"; };
    };

    video.hidpi.enable = true;

    nvidia = lib.mkIf config.modules.hardware.nvidia.enable {
      modesetting.enable = true;
      open = true;
      prime = {
        offload.enable = true;

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # thunderbolt
  services.hardware.bolt.enable = true;

  # thermal monitoring
  services.thermald.enable = true;
  services.thermald.package = pkgs.my.thermald;

  # irq balancing
  services.irqbalance.enable = true;

  # battery management
  services.upower.enable = true;

  # save some electricy
  powerManagement.enable = true;

  # improve cpu balancing a bit
  services.ananicy.enable = false;
  services.ananicy.package = pkgs.ananicy-cpp;

  systemd.oomd.enableRootSlice = true;
  systemd.oomd.enableSystemSlice = true;
  systemd.oomd.enableUserServices = true;

  systemd.enableCgroupAccounting = true;
  systemd.enableUnifiedCgroupHierarchy = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;
  services.earlyoom.enableDebugInfo = false;

  services.udisks2.enable = true;

  programs.light.enable = true;

  # CPU
  nix.settings.max-jobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = true;

  # Storage
  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/14c3182f-f307-466a-8de3-b750e11ed995";
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/6e6f01d5-826a-40e9-8fa7-cfcc4616dd92";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C04A-6D05";
    fsType = "vfat";
  };

  fileSystems."/mnt/nas/homes" = {
    device = "192.168.86.34:/volume1/homes";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nas/backup" = {
    device = "192.168.86.34:/volume1/backup";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nas/music" = {
    device = "192.168.86.34:/volume1/music";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nas/movies" = {
    device = "192.168.86.34:/volume1/movies";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  swapDevices = [{
    device = "/swapfile";
    size = 10240;
  }];

  # services.udev.extraRules = ''
  #   ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
  #   ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
  #   SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
  #   KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
  # '';
}
