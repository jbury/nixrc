
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.vanta-agent;
in
{
  options.modules.services.vanta-agent = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (
      {
        environment.systemPackages = [ pkgs.vanta-agent ];

        systemd.services.vanta =
          {
            after = [ "network.service" "syslog.service" ];
            description = "Vanta monitoring software";
            wantedBy = [ "multi-user.target" ];
            preStart = ''
              cp -a ${pkgs.vanta-agent}/var/vanta /var
            '';
            script = ''
              /var/vanta/metalauncher
            '';

            serviceConfig = {
              TimeoutStartSec = 0;
              Restart = "on-failure";
              KillMode = "control-group";
              KillSignal = "SIGTERM";
            };
          };
      }
  );
}
