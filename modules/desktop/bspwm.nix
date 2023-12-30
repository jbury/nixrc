{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.bspwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.bspwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.theme.onReload.bspwm = ''
      ${pkgs.bspwm}/bin/bspc wm -r
      pkill -USR1 -x sxhkd
    '';

    environment.systemPackages = with pkgs; [
      lightdm
      betterlockscreen
      dunst
      libnotify
      xorg.xev
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    services = {
      autorandr.enable = true;
      picom.enable = true;
      xserver = {
        enable = true;

        windowManager.bspwm.enable = true;

        displayManager = {
          defaultSession = "none+bspwm";

          lightdm = {
            enable = true;
            greeters.mini = {
              enable = true;
              user = config.user.name;
            };
          };
        };
      };
    };

    systemd = {
      user = {
        # https://discourse.nixos.org/t/systemd-user-units-and-no-such-path/8399
        # Forces systemd to actually like, point at some bins, or whatever.
        extraConfig = ''
          DefaultEnvironment="PATH=/run/current-system/sw/bin:/etc/nixos/bin"
        '';
        services = {
          dunst = {
            enable = true;
            description = "";
            wantedBy = [ "default.target" ];
            serviceConfig.Restart = "always";
            serviceConfig.RestartSec = 2;
            serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
          };

          work-screenshot = {
            script = "${config.dotfiles.binDir}/work_screenshot";
            serviceConfig.Type = "oneshot";
            path = [ pkgs.cached-nix-shell ];
          };
        }; # end of services

        timers = {
          work-screenshot = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "*:00/10:00";
              Unit = "work-screenshot.service";
            };
          };
        }; # end of timers
      };
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
      "bspwm" = {
        source = "${configDir}/bspwm";
        recursive = true;
      };
    };
  };
}
