{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.waybar;
  settings = config.settings;
in {
  options.modules.desktop.waybar = { enable = mkBoolOpt config.modules.desktop.swaywm.enable; };

  config = mkIf cfg.enable {
    home.programs.waybar = {
      enable = true;

      systemd.enable = true;

      settings = [{
        layer = "bottom";
        position = "top";
        height = 40;
        spacing = 10;

        modules-left = [
          "cpu"
          "temperature"
          "network#1"
          "network#2"
          "pulseaudio"
          "battery"
          "clock"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [ "sway/workspaces" "sway/mode" ];

        "cpu" = {
          format = "{usage}% ";
          interval = 1;
          tooltip = true;
        };

        "temperature" = {
          interval = 2;
#          hwmon-path-abs = settings.sensors.cpu_temp;
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "network#1" = {
          interval = 2;
          interface = "eth0";
          format-ethernet = "";
          format-disconnected = "";
          tooltip = true;
          tooltip-format-ethernet = ''
            {ipaddr}/{cidr}
             {bandwidthDownBits}
             {bandwidthUpBits}'';
        };

        "network#2" = {
          interval = 2;
          interface = "wlan0";
          format = "";
          format-wifi = "";
          format-disconnected = "";
          format-disabled = "";
          format-icons = [];
          tooltip = true;
          tooltip-format-wifi = ''
            {essid} {frequency}Ghz
            {ipaddr}/{cidr}
            {signalStrength}   
            {signaldBm} db
             {bandwidthDownBits}
             {bandwidthUpBits}'';
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-muted = "Muted ";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          scroll-step = 5.0;
          tooltip = true;
        };

        "battery" = {
#          bat = settings.sensors.battery;
          bat = "BAT1";
          interval = 5;
          states = {
              warning = 30;
              critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = true;
        };

        "clock" = {
          format = "<b>{:%I:%M %p}</b>";
          today-format = "<b><u>{}</u></b>";
          tooltip = true;
          tooltip-format = ''
            <big>{:%a, %B %e %Y}</big>
            <tt><small>{calendar}</small></tt>
          '';
        };
      }];
    };
  };
}
