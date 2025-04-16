{ lib, inputs, ... }:

let inherit (lib) mkDefault;
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = "24.11";
      wsl.enable = true;
    }
  ];

  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
}
