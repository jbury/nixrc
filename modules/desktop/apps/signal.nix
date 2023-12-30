{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) makeDesktopItem signal-desktop;

  cfg = config.modules.desktop.apps.signal;
in {
  options.modules.desktop.apps.signal = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      signal-desktop
      (makeDesktopItem {
        name = "signal-desktop";
        desktopName = "Signal Desktop";
        genericName = "Open Signal Desktop";
        icon = "signal-desktop";
        exec =
          "${signal-desktop}/bin/signal-desktop --ozone-platform-hint=auto";
        categories = [ "Network" ];
      })
    ];
  };
}
