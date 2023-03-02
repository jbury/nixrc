{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.signal;
in {
  options.modules.desktop.apps.signal = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      signal-desktop
      (makeDesktopItem {
        name = "signal-desktop";
        desktopName = "Signal Desktop";
        genericName = "Open Signal Desktop";
        icon = "signal-desktop";
        exec = "${signal-desktop}/bin/signal-desktop --ozone-platform-hint=auto";
        categories = ["Network"];
      })
    ];
  };
}
