{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.waybar;
  colorscheme = config.lib.stylix;
  fonts = config.stylix.fonts;
in {
  options.modules.desktop.apps.waybar = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.programs = {
      waybar.enable = true;
      waybar.settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 30;

          modules-left = ["cpu" "memory" "pulseaudio" "sway/mode"];
          modules-center = ["sway/workspaces"];
          modules-right = ["idle_inhibitor" "network" "battery" "tray" "clock"];

          battery = {
            interval = 10;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "  {icon}  {capacity}%";
            format-discharging = "{icon}  {capacity}%";
            format-full = "";
            format-icons = [ "" "" "" "" "" ];
            tooltip = true;
          };

          "clock#time" = {
            interval = 1;
            format = "{:%H:%M:%S}";
            tooltip = false;
          };

          "clock#date" = {
            interval = 10;
            format = "  {:%e %b %Y}";
            tooltip-format = "{:%e %B %Y}";
          };

          clock = {
            interval = 10;
            format = "{:%A, %h %d %I:%M %p}";
          };

          cpu = {
            interval = 5;
            format = "  {usage}% ({load})";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          "custom/keyboard-layout" = {
            exec = "swaymsg -t get_inputs | grep -m1 'xkb_active_layout_name' | cut -d '\"' -f4";
            interval = 30;
            format = "  {}";
            signal = 1;
            tooltip = false;
          };

          memory = {
            interval = 5;
            format = "  {}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          network = {
            interval = 5;
            format-wifi = "  ({signalStrength}%)";
            format-ethernet = "";
            format-disconnected = "⚠  Disconnected";
            tooltip-format = "{ifname}: {essid} - {ipaddr}";
          };

          "sway/mode" = {
            format = "<span style=\"italic\">  {}</span>";
            tooltip = false;
          };

          "sway/window" = {
            format = "{}";
            max-length = 120;
          };

          "sway/workspaces" = {
            all-outputs = false;
            disable-scroll = true;
            format = "{name}";
            format-icons = {
              "1:www" = "龜";
              "2:mail" = "";
              "3:editor" = "";
              "4:terminals" = "";
              "5:portal" = "";
              "urgent" = "";
              "focused" = "";
              "default" = "";
            };
            persistent_workspaces = {
              "1" = ["DP-5"];
              "2" = ["DP-3"];
              "3" = ["eDP-1"];
              "4" = [];
              "5" = [];
              "6" = [];
            };
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            format-bluetooth = "{icon}  {volume}%";
            format-muted = "";
            format-icons = {
              headphones = "";
              handsfree = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" ""];
            };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          temperature = {
            critical-threshold = 80;
            interval = 5;
            format = "{icon}  {temperatureC}°C";
            format-icons = [ "" "" "" "" "" ];
            tooltip = true;
          };

          tray = {
            icon-size = 21;
            spacing = 10;
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
        };
      };

      waybar.style = ''
        @keyframes blink-warning {
            70% {color: #${colorscheme.colors.base0A};}
            to {color: #${colorscheme.colors.base05}; background-color: #${colorscheme.colors.base0A};}
        }

        @keyframes blink-critical {
            70% {color: #${colorscheme.colors.base08};}
            to {color: #${colorscheme.colors.base05}; background-color: #${colorscheme.colors.base08};}
        }

        * {
            border: none;
            border-radius: 0;
            min-height: 0;
            min-width: 0;
            margin: 0;
            padding: 0;
        }

        #waybar {
            background: #${colorscheme.colors.base00};
            color: #${colorscheme.colors.base05};
            font-family: "${fonts.sansSerif.name}", "Font Awesome 5 Free";
            font-size: 13px;
        }

        #battery,
        #clock,
        #cpu,
        #custom-keyboard-layout,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #temperature,
        #tray {
            padding-left: 10px;
            padding-right: 10px;
        }

        #battery {
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #battery.warning {
            color: #${colorscheme.colors.base0A};
        }

        #battery.critical {
            color: #${colorscheme.colors.base08};
        }

        #battery.warning.discharging {
            animation-name: blink-warning;
            animation-duration: 3s;
        }

        #battery.critical.discharging {
            animation-name: blink-critical;
            animation-duration: 2s;
        }

        #clock {}
        #cpu {}

        #cpu.warning {
            color: #${colorscheme.colors.base0A};
        }

        #cpu.critical {
            color: #${colorscheme.colors.base08};
        }

        #memory {
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #memory.warning {
            color: #${colorscheme.colors.base0A};
        }

        #memory.critical {
            color: #${colorscheme.colors.base08};
            animation-name: blink-critical;
            animation-duration: 2s;
        }

        #mode {
            background: #${colorscheme.colors.base01};
        }

        #network {}

        #network.disconnected {color: #${colorscheme.colors.base0A};}
        #pulseaudio {}
        #pulseaudio.muted {}
        #custom-spotify {color: rgb(102, 220, 105);}
        #temperature {}
        #temperature.critical {color: #${colorscheme.colors.base08};}
        #tray {}
        #window {font-weight: bold;}

        #workspaces button {
            padding-left: 10px;
            padding-right: 10px;
            color: #${colorscheme.colors.base05};
        }

        #workspaces button.focused {
            color: #${colorscheme.colors.base05};
            background-color: #${colorscheme.colors.base01};
        }

        #workspaces button.urgent {
            background-color: #${colorscheme.colors.base08};
        }
      '';
    };
  };
}
