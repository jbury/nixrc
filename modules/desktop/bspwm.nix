{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.bspwm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.bspwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.theme.onReload.bspwm = ''
      ${pkgs.bspwm}/bin/bspc wm -r
      autorandr -c
      source $XDG_CONFIG_HOME/bspwm/bspwmrc
    '';

    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
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
        displayManager = {
          defaultSession = "none+bspwm";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
          lightdm.greeters.mini.user = config.user.name;
        };
        windowManager.bspwm.enable = true;
      };
    };

    systemd.user.services = {
      dunst = {
        enable = true;
        description = "";
        wantedBy = [ "default.target" ];
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = 2;
        serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
      };
      xsetroot = {
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr";
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
