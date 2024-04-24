{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) writeScriptBin stdenv;

  cfg = config.modules.desktop.core.bspwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.core.bspwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
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
        services = {
          dunst = {
            enable = true;
            description = "";
            wantedBy = [ "default.target" ];
            serviceConfig.Restart = "always";
            serviceConfig.RestartSec = 2;
            serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
          };
        };
      };
    };

    user.packages = [
      (writeScriptBin "reui" ''
        #!${stdenv.shell}
        monitors="$(xrandr --listmonitors | head -n1 | cut -d' ' -f2)"
        echo "Detected ''${monitors} monitors"
        case $monitors in
          1)
            autorandr -c "single"
            ;;
          2)
            autorandr -c "double"
            ;;
          3)
            autorandr -c "multi"
            ;;
          *)
            autorandr -c "single"
            ;;
        esac

        ${pkgs.bspwm}/bin/bspc wm -r
        pkill -USR1 -x sxhkd
      '')
    ];

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
