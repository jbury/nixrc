
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.types) str;
  inherit (lib.my) mkOpt mkBoolOpt;

  cfg = config.modules.services.networking.tailscale;
in
{
  options.modules.services.networking.tailscale = {
    enable = mkBoolOpt false;
    hostname = mkOpt str "";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
      extraUpFlags = mkIf cfg.hostname [
        "--hostname ${cfg.hostname}"
        "--accept-routes"
      ];
    };

    modules.shell.zsh.aliases.tss = "tailscale status";
  };
}
