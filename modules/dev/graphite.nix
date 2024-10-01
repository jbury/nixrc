# modules/dev/graphite.nix
#
# I guess it's a better code review UI?

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.graphite;
in {
  options.modules.dev.graphite = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.graphite-cli
    ];
  };

}
