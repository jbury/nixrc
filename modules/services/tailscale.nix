
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.types) str;
  inherit (lib.my) mkOpt mkBoolOpt;

  cfg = config.modules.services.tailscale;
in
{
  options.modules.services.tailscale = {
    enable = mkBoolOpt false;
    hostname = mkOpt str "";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = mkIf cfg.hostname [
        "--hostname ${cfg.hostname}"
      ];
    };
  };
}
