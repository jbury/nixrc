
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkDefault;
  inherit (lib.types) str;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.vanta-agent;
in
{
  options.modules.services.vanta-agent = {
    enable = mkBoolOpt false;

    agentKey = mkOption {
      type = str;
    };

    email = mkOption {
      type = str;
    };
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
              sed \
                -e 's/\("AGENT_KEY": "\)"/\1${cfg.agentKey}"/1' \
                -e 's/\("OWNER_EMAIL": "\)"/\1${cfg.email}"/' \
                ${pkgs.vanta-agent}/etc/vanta.conf > /etc/vanta.conf
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
