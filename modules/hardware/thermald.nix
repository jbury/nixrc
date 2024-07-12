{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.hardware.thermald;
in {
  options.modules.hardware.thermald = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    users.groups.power = {};

    services.thermald.enable = true;
  };
}
