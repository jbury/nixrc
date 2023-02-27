{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.slack;
in {
  options.modules.desktop.apps.slack = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      slack
      (makeDesktopItem {
        name = "slack-wayland";
        desktopName = "Slack (Wayland)";
        genericName = "Open Slack as a Wayland app";
        icon = "slack";
        exec = "${slack}/bin/slack --ozone-platform-hint=auto";
        categories = ["Network"];
      })
    ];
  };
}
