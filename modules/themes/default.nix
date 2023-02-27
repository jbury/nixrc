# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v:
        let theme = builtins.getEnv "THEME";
        in if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    onReload = mkOpt (attrsOf lines) { };
  };

  config = mkIf (cfg.active != null) (mkMerge [
    {
      home-manager.users.${config.user.name}.gtk = {
        gtk3 = {
          extraConfig = {
            gtk-application-prefer-dark-theme = true;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintfull";
            gtk-xft-rgba = "none";
          };
        };
        gtk4 = {
          extraConfig = {
            gtk-application-prefer-dark-theme = true;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintfull";
            gtk-xft-rgba = "none";
          };
        };
      };
    }
    (mkIf (cfg.onReload != { }) (let
      reloadTheme = with pkgs;
        (writeScriptBin "reloadTheme" ''
          #!${stdenv.shell}
          echo "Reloading current theme: ${cfg.active}"
          ${concatStringsSep "\n" (mapAttrsToList (name: script: ''
            echo "[${name}]"
            ${script}
          '') cfg.onReload)}
        '');
    in {
      user.packages = [ reloadTheme ];
      system.userActivationScripts.reloadTheme = ''
        [ -z "$NORELOAD" ] && ${reloadTheme}/bin/reloadTheme
      '';
    }))
  ]);
}
