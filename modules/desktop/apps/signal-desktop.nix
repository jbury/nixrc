{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.signal-desktop;
in {
  options.modules.desktop.apps.signal-desktop = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      signal-desktop
      (makeDesktopItem {
        name = "signal-desktop-wayland";
        desktopName = "Signal Desktop (Wayland)";
        genericName = "Open Signal Desktop as a Wayland app";
        icon = "signal-desktop";
        exec = "${signal-desktop}/bin/signal-desktop --ozone-platform-hint=auto";
        categories = ["Network"];
      })
    ];
  };
}
