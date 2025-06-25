{ config, lib, ... }:

let
  inherit (lib.types) str;
  inherit (lib.my) mkOpt;
in {
  # Defaults and options that I'll set at the per-host level if needed
  options.hostSettings = {
    userName = mkOpt str "jbury";
    hostName = mkOpt str config.networking.hostName;
    email    = mkOpt str "jasondougbury@gmail.com";
  };
}
