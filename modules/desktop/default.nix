{ config, lib, pkgs, ... }:

let
  inherit (builtins) isAttrs;
  inherit (lib) mkIf value;
  inherit (lib.my) anyAttrs countAttrs;

  cfg = config.modules.desktop;
in {
  config = mkIf (config.services.xserver.enable || cfg.swaywm.enable) {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message =
          "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion = let srv = config.services;
        in srv.xserver.enable || cfg.swaywm.enable || !(anyAttrs
          (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = [
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.gparted
      pkgs.feh
      pkgs.keepassxc
      pkgs.sway-contrib.grimshot
      pkgs.xclip
      pkgs.qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
      pkgs.xdg-utils
      pkgs.optipng # I take a _lot_ of screenshots, so making them small is nice
    ];

    modules.shell.zsh.aliases.y = "xclip -selection clipboard -in";
    modules.shell.zsh.aliases.p = "xclip -selection clipboard -out";

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      enableDefaultPackages = true;
      packages = [
        pkgs.iosevka-bin
        (pkgs.iosevka-bin.override { variant = "Etoile"; })
        (pkgs.iosevka-bin.override { variant = "Aile"; })
        (pkgs.iosevka-bin.override { variant = "SGr-IosevkaFixed"; })

        pkgs.noto-fonts-emoji
      ];

      fontconfig.defaultFonts = {
        serif = [ "Iosevka Etoile" ];
        sansSerif = [ "Iosevka Aile" ];
        monospace = [ "Iosevka Term" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";

    env.XDG_SCREENSHOTS_DIR = "${config.user.home}/screenshots";

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
        rm -rf .compose-cache .nv .pki .dbus .fehbg
      popd
    '';
  };
}
