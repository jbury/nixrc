{ lib, config, modulesPath, inputs, ... }:

let inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # fwupd needed for firmware updates
  services.fwupd.enable = true;

  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = mkDefault "powersave";

  hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

  ### Laptop hardware
  # Just the touchpad for now
  services.libinput.enable = true;
}
