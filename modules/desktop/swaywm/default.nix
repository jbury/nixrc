{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf concatMapStringsSep cartesianProduct;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) writeScriptBin stdenv;

  cfg = config.modules.desktop.swaywm;
  configDir = config.dotfiles.configDir;
  swayConfig = config.home-manager.users.${config.user.name}.wayland.windowManager.sway.config;
in {
  options.modules.desktop.swaywm = { enable = mkBoolOpt false; };
  imports = [ ./keybindings.nix ];

  config = mkIf cfg.enable {
    # Wayland needs strict security policy stuff
    security.polkit.enable = true;


    # Make super sure we aren't running X alongside Wayland
    services = {
      xserver.enable = lib.mkDefault false;

      udev.extraRules = ''
        KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
      '';
    };

    home.wayland.windowManager.sway = {
      enable = true;
      xwayland = true;

      config = {
        terminal = "${pkgs.foot}/bin/foot";

        window.titlebar = false;
        floating.titlebar = false;

        focus = {
          followMouse = false;
          mouseWarping = "container";
          newWindow = "smart";
        };

        gaps = {
          inner = 8;
          smartGaps = true;
        };

        output = {
          eDP-1 = {
            mode = "2256x1504@60Hz";
            position = "1184,1440";
            scale = "1.0";
          };

          "ASUSTek COMPUTER INC ASUS VG35V 0x000207A6" = {
            mode = "3440x1440@60Hz";
            position = "0,0";
            scale = "1.0";
          };

          "LG Electronics LG ULTRAGEAR+ 405NTWG5L201" = {
            mode = "3840x2160@60Hz";
            position = "3440,720";
            scale = "1.0";
          };
        };

        workspaceOutputAssign = [
          {
            output = "eDP-1";
            workspace = "1";
          }
          {
            output = "ASUSTek COMPUTER INC ASUS VG35V 0x000207A6";
            workspace = "2";
          }
          {
            output = "LG Electronics LG ULTRAGEAR+ 405NTWG5L201";
            workspace = "3";
          }
        ];

        bars = [ ];

        startup = [
          {
            command = "$DOTFILES/bin/laptop.sh";
            always = true;
          }
          {
            command =
              "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob";
            always = false;
          }
          {
            command = "${pkgs.autotiling}/bin/autotiling";
            always = false;
          }
          {
            command = "${pkgs.swayr}/bin/swayrd";
            always = false;
          }
          {
            command =
              "${pkgs.ydotool}/bin/ydotoold --socket-path=/run/user/%U/.ydotool_socket --socket-perm=0600 --socket-own %U:%G";
            always = false;
          }
        ];
      };
      extraConfig = ''
        input "type:keyboard" {
          xkb_options ctrl:nocaps
          xkb_numlock enable
          repeat_delay 200
          repeat_rate 30
        }
      '';

      extraSessionCommands = ''
        export MOZ_DBUS_REMOTE=1
        export MOZ_WEBRENDER=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export NIXOS_OZONE_WL=1
        export NIXOS_OZON_PLATFORM=wayland;
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
        export LIBVA_DRIVER_NAME=iHD
     '';

     wrapperFeatures = {
        gtk = true;
        base = true;
      };

      systemd.enable = true;
      swaynag.enable = true;
    };

    security.pam.services.swaylock = {};
    home.programs.swaylock.enable = true;

    home.services = {
      mpris-proxy.enable = true;

      swayidle = {
        enable = true;

        timeouts = [
          {
            timeout = 600;
            command = "${pkgs.swaylock}/bin/swaylock -fFe -c000000";
          }
        ];

        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -fFe -c000000";
          }
        ];
      };

      mako = let
        iconPath = let
          basePaths = [
            "/run/current-system/sw"
            config.home-manager.users.${config.user.name}.home.profileDirectory
          ];
          themes = [ "Paper" "Paper-Mono-Dark" "Adwaita" "hicolor" ];
          mkPath = { basePath, theme, }: "${basePath}/share/icons/${theme}";
        in concatMapStringsSep ":" mkPath (cartesianProduct {
          basePath = basePaths;
          theme = themes;
        });
      in {
        inherit iconPath;

        enable = true;
        output = "eDP-1";
        actions = true;
        anchor = "top-right";
        borderRadius = 2;
        borderSize = 1;
        height = 1000;
        icons = true;
        # I know better than you, notification sender.
        ignoreTimeout = true;
        defaultTimeout = 10;
        margin = "4,26";
        markup = true;
        maxVisible = -1;
        padding = "20,16";
        width = 440;
      };
    };

    environment.systemPackages = with pkgs; [
      autotiling
      gammastep
      grim
      qt5.qtwayland
      remontoire
      sirula
      slurp
      sov
      sway-contrib.grimshot
      swaybg
      swayidle
      swayr
      wayvnc
      wev
      wl-clipboard
      wlr-randr
      wob
      wofi
      ydotool
    ];
  };
}
