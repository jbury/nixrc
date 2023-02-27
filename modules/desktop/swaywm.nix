{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.swaywm;
  colorscheme = config.lib.stylix;
  fonts = config.stylix.fonts;
in {
  options.modules.desktop.swaywm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

    # assumes user id of 1000
    modules.theme.onReload.swaywm = ''
      swaySocket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(${pkgs.procps}/bin/pgrep --uid $UID -x sway || true).sock"
      if [ -S "$swaySocket" ]; then
        ${pkgs.sway}/bin/swaymsg -s $swaySocket reload
      fi
    '';

    services = { xserver.enable = false; };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      wlr.settings = {
        screencast = {
          output_name = "DP-4";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
      extraPortals = with pkgs;
        [
          xdg-desktop-portal-wlr
          # xdg-desktop-portal-gtk
        ];
      # gtkUsePortal = true;
    };

    programs.sway = {
      enable = true;
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_WEBRENDER=1
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
        export NIXOS_OZONE_WL=1
        # xrdb -merge "$XDG_CONFIG_HOME"/xtheme/*

        export XCURSOR_PATH="${pkgs.paper-icon-theme}/share/icons"
        export XCURSOR_THEME="Paper"
      '';

      wrapperFeatures = {
        gtk = true;
        base = true;
      };

      extraPackages = with pkgs; [
        swaylock
        swayidle
        swaybg
        # waybar
        # (wofi.override { wayland = _wayland_newer; })
        wofi
        mako
        kanshi
        wob
        qt5.qtwayland
        grim
        slurp
        sway-contrib.grimshot
        xdg-desktop-portal-wlr
        gtk-layer-shell
        wl-clipboard
        autotiling
        # wlay
        wlr-randr
        brightnessctl
        wev
        polkit_gnome
        gtk-engine-murrine
        gtk_engines
        gsettings-desktop-schemas
        gnome.adwaita-icon-theme
        hicolor-icon-theme
        # my.flashfocus
        polkit_gnome
        # i3status-rust
        gammastep
        wayvnc
        # wlvncc
        playerctl
        # foot
        my.remontoire
        # my.swaycons
        swayr
        my.fuzzel
        sirula

        i3status-rust

        my.swaywindow

        (pkgs.writeShellScriptBin "run-sway" ''
          /run/current-system/systemd/bin/systemctl --user start graphical-session.target
          LIBVA_DRIVER_NAME=iHD WLR_DRM_NO_MODIFIERS=1 dbus-run-session sway
          /run/current-system/systemd/bin/systemctl --user stop graphical-session.target
        '')
      ];
    };

    programs.waybar.enable = true;

    home-manager.users.${config.user.name}.programs = {
      mako = {
        enable = true;
        actions = true;
        anchor = "top-right";
        backgroundColor = "#${colorscheme.colors.base00}";
        borderColor = "#${colorscheme.colors.base0D}";
        borderRadius = 2;
        borderSize = 1;
        defaultTimeout = 14000;
        font = fonts.sansSerif.name;
        height = 1000;
        icons = true;
        ignoreTimeout = true;
        margin = "4,26";
        markup = true;
        maxVisible = -1;
        padding = "20,16";
        textColor = "#${colorscheme.colors.base05}";
        width = 440;
        extraConfig = ''
          [app-name="Slack"]
          group-by=summary
        '';
      };
    };

    systemd.user.services.autotiling = {
      description = "Sway autotiling";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.autotiling}/bin/autotiling";
    };

    systemd.user.services.gammastep = {
      description = "Screen color temperature manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.gammastep}/bin/gammastep -l 47.553341:-122.370537";
    };

    systemd.user.services.mako = {
      description = "Mako notifications";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.mako}/bin/mako";
    };

    systemd.user.services.kanshi = {
      description = "Kanshi display configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.kanshi}/bin/kanshi";
    };

    systemd.user.services.mpris-proxy = {
      description = "mpris-proxy";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.bluez}/bin/mpris-proxy";
    };

    # systemd.user.services.flashfocus = {
    #   description = "flashfocus";
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   script = "${pkgs.my.flashfocus}/bin/flashfocus";
    #   path = with pkgs; [ procps ];
    # };

    systemd.user.services.swayrd = {
      description = "swayrd";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.swayr}/bin/swayrd";
      path = with pkgs; [ wofi ];
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sway" = {
        source = "${config.dotfiles.configDir}/sway";
        recursive = true;
      };
    };
  };
}
