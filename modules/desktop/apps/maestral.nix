{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.maestral;
in {
  options.modules.desktop.apps.maestral = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.maestral
      unstable.maestral-gui
    ];

    home-manager.users.${config.user.name}.systemd.user.services."maestral-daemon@maestral" = {
      Unit = {
        Description = "Maestral daemon for the config %i";
      };

      Service = {
        Type = "notify";
        ExecStart = "${pkgs.maestral}/bin/maestral start -f -c %i";
        ExecStop = "${pkgs.maestral}/bin/maestral stop";
        WatchdogSec = "30s";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # systemd.user.services.maestral = {
    #   description = "Maestral Dropbox Client";
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.maestral-gui}/bin/maestral_qt";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };
  };
}
