{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) writeScriptBin stdenv;

  cfg = config.modules.desktop.bspwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.bspwm = { enable = mkBoolOpt false; };

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
      arandr # Beautiful xrandr GUI layout tool for generating monitor layout configs
    ];

    services = {
      autorandr.enable = true;

      picom.enable = true;

      displayManager = {
        defaultSession = "none+bspwm";
      };

      xserver = {
        enable = true;

        xautolock = {
          enable = true;
          enableNotifier = true;
          nowlocker = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
          time = 5;
          notify = 30;
          notifier = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds'";
        };

        windowManager.bspwm.enable = true;

        displayManager = {
          lightdm = {
            enable = true;
            greeters.mini = {
              enable = true;
              user = config.user.name;
            };
          };
        };
      };

      picom = {
        backend = "glx";
        vSync = true;
        opacityRules = [
          "100:class_g = 'VirtualBox Machine'"
          # Art/image programs where we need fidelity
          "100:class_g = 'Gimp'"
          "100:class_g = 'Inkscape'"
          "100:class_g = 'aseprite'"
          "100:class_g = 'krita'"
          "100:class_g = 'feh'"
          "100:class_g = 'mpv'"
          "100:class_g = 'Rofi'"
          "100:class_g = 'Peek'"
          "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
        ];
        shadowExclude = [
          # Put shadows on notifications, rofi only
          "! name~='(rofi|Dunst)$'"
        ];
        settings = {
          blur-background-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
            "class_g = 'Rofi'"
            "_GTK_FRAME_EXTENTS@:c"
          ];

          # Unredirect all windows if a full-screen opaque window is detected, to
          # maximize performance for full-screen windows. Known to cause
          # flickering when redirecting/unredirecting windows.
          unredir-if-possible = true;

          # GLX backend: Avoid using stencil buffer, useful if you don't have a
          # stencil buffer. Might cause incorrect opacity when rendering
          # transparent content (but never practically happened) and may not work
          # with blur-background. My tests show a 15% performance boost.
          # Recommended.
          glx-no-stencil = true;
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

          #work-screenshot = {
          #  script = "${config.dotfiles.binDir}/work_screenshot";
          #  serviceConfig.Type = "oneshot";
          #  path = [ pkgs.cached-nix-shell ];
          #};
        }; # end of services

        timers = {
          #work-screenshot = {
          #  wantedBy = [ "timers.target" ];
          #  timerConfig = {
          #    OnCalendar = "*:00/10:00";
          #    Unit = "work-screenshot.service";
          #  };
          #};
        }; # end of timers
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
