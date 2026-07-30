{ lib, ... }:

let inherit (lib) mkDefault;
in {
  nixpkgs.hostPlatform = mkDefault "aarch64-darwin";
}
