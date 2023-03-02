{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
    profileName = mkOpt types.str config.user.name;

    settings = mkOpt' (attrsOf (oneOf [ bool int str ])) {} ''
      Firefox preferences to set in <filename>user.js</filename>
    '';
    extraConfig = mkOpt' lines "" ''
      Extra lines to add to <filename>user.js</filename>
    '';

    userChrome  = mkOpt' lines "" "CSS Styles for Firefox's interface";
    userContent = mkOpt' lines "" "Global CSS Styles for websites";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        firefox
        (makeDesktopItem {
          name = "firefox";
          desktopName = "Firefox";
          genericName = "Open a Firefox window";
          icon = "firefox";
          exec = "${firefox-bin}/bin/firefox";
          categories = [ "Network" ];
        })
      ];

      env.XDG_DESKTOP_DIR = "$HOME/";

      # Use a stable profile name so we can target it in themes
      home.file = let cfgPath = ".mozilla/firefox"; in {
        "${cfgPath}/profiles.ini".text = ''
          [Profile0]
          Name=default
          IsRelative=1
          Path=${cfg.profileName}.default
          Default=1
          [General]
          StartWithLastProfile=1
          Version=2
        '';

        "${cfgPath}/${cfg.profileName}.default/user.js" =
          mkIf (cfg.settings != {} || cfg.extraConfig != "") {
            text = ''
              ${concatStrings (mapAttrsToList (name: value: ''
                user_pref("${name}", ${builtins.toJSON value});
              '') cfg.settings)}
              ${cfg.extraConfig}
            '';
          };

        "${cfgPath}/${cfg.profileName}.default/chrome/userChrome.css" =
          mkIf (cfg.userChrome != "") {
            text = cfg.userChrome;
          };

        "${cfgPath}/${cfg.profileName}.default/chrome/userContent.css" =
          mkIf (cfg.userContent != "") {
            text = cfg.userContent;
          };
      };
    }
  ]);
}
