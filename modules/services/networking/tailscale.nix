
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
    networking.firewall = {
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };

    systemd = {
      services.tailscaled = {
        after = [ "network-online.target" "systemd-resolved.service" ];
        wants = [ "network-online.target" "systemd-resolved.service" ];
      };
    };

    services.tailscale = {
      enable = true;
      extraUpFlags = mkIf cfg.hostname [
        "--hostname ${cfg.hostname}"
      ];
    };
  };
}
