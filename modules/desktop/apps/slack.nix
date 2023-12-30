{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) makeDesktopItem slack;

  cfg = config.modules.desktop.apps.slack;
in {
  options.modules.desktop.apps.slack = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      slack
      (makeDesktopItem {
        name = "slack";
        desktopName = "Slack";
        genericName = "Open Slack";
        icon = "slack";
        exec = "${slack}/bin/slack --ozone-platform-hint=auto";
        categories = [ "Network" ];
      })
    ];

    modules.shell.zsh.aliases.fix-slack = "rm -rf ~/.config/Slack/GPUCache";
  };
}
