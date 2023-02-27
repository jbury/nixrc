{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.email.mu4e;
in {
  options.modules.email.mu4e = {
    enable = mkBoolOpt false;
    package = mkOption  {
      type = types.package;
      default = pkgs.offlineimap;
      defaultText = "pkgs.offlineimap";
      description = "Offlineimap derivation to use";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      cfg.package
      # don't install mu4e here
      mu
      imapfilter
      isync-oauth2
      msmtp
      my.pizauth
    ];

    home-manager.users.${config.user.name}.systemd.user = {
      startServices = "sd-switch";
      services = {
        "pizauth" = {
          Unit = {
            Description = "OAuth2 Service Daemon";
            ConditionPathExists="%h/.config/pizauth.conf";
            After="network.target";
          };

          Service = {
            Environment = "PATH=${pkgs.libnotify}/bin:$PATH";
            ExecStart = "${pkgs.my.pizauth}/bin/pizauth server -dvc %h/.config/pizauth.conf";
            Restart = "always";
            RestartSec = "30";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        "goimapnotify@flexe" = {
          Unit = {
            Description = "IMAP notifier using IDLE, golang version.";
            ConditionPathExists="%h/.config/imapnotify/%I/notify.conf";
            After="network.target";
          };

          Service = {
            Environment="PATH=${pkgs.isync-oauth2}/bin:${pkgs.mu}/bin:${pkgs.my.pizauth}/bin:$PATH";
            ExecStart = "${pkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
            Restart = "always";
            RestartSec = "30";
          };

          # path = with pkgs; [ isync mu ];

          Install = {
            WantedBy = [ "default.target" ];
          };
          # wantedBy = [ "multi-user.target" ];
          # partOf = [ "multi-user.target" ];
        };

        "goimapnotify@fooninja" = {
          Unit = {
            Description = "IMAP notifier using IDLE, golang version.";
            ConditionPathExists="%h/.config/imapnotify/%I/notify.conf";
            After="network.target";
          };

          Service = {
            Environment="PATH=${pkgs.isync-oauth2}/bin:${pkgs.mu}/bin:${pkgs.my.pizauth}/bin:$PATH";
            ExecStart = "${pkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
            Restart = "always";
            RestartSec = "30";
          };

          # path = with pkgs; [ isync mu ];

          Install = {
            WantedBy = [ "default.target" ];
          };
          # wantedBy = [ "multi-user.target" ];
          # partOf = [ "multi-user.target" ];
        };

        mbsync = {
          Unit = {
            Description = "mbsync service, sync all mail";
            ConditionPathExists="%h/.mbsyncrc";
            Documentation="man:mbsync(1)";
          };

          # Install = {
          #   WantedBy = [ "default.target" ];
          # };

          Service = {
            Environment="PATH=${pkgs.my.pizauth}/bin:$PATH";
            Type = "oneshot";
            ExecStart = "${pkgs.isync-oauth2}/bin/mbsync -c %h/.mbsyncrc --all";
          };
        };
      };

      timers = {
        mbsync = {
          Unit = {
            Description = "call mbsync on all accounts every 15 m";
            ConditionPathExists="%h/.mbsyncrc";
          };

          Timer = {
            Unit = "mbsync.service";
            OnCalendar = "*:0/15";
            Persistent = "true";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
  };
}
