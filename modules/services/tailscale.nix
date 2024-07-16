
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.tailscale;
in
{
  options.modules.services.tailscale = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
