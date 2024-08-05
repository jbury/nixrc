{ config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.networking.resolved;
in {
  config = {
    networking = {
      nftables.enable = true;

      firewall = {
        allowedTCPPorts = [ 5355 ];
        allowedUDPPorts = [ 5355 5353 ];
      };
      networkmanager.dns = "systemd-resolved";
    };

    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      llmnr = "false";
    };
  };
}
