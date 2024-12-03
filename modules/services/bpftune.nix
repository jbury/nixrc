{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.bpftune;
in
{
  options.modules.services.bpftune = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable (
    services.bfptune = {
      enable = true;
    };
  );
}
