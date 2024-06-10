{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) scrot optipng;

  cfg = config.modules.desktop.extras.screensnap;
in {
  options.modules.desktop.extras.screensnap = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      scrot
      optipng
    ];

    systemd = {
      user = {
        services = {
          scheduled-screensnap = {
            script = "${config.dotfiles.binDir}/scrsnap";
            serviceConfig.Type = "oneshot";
            path = [ pkgs.cached-nix-shell ];
          };
        };
        timers = {
          scheduled-screensnap = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "*:00/10:00";
              Unit = "scheduled-screensnap.service";
            };
          };
        };
      };
    };
  };
}
