{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) makeDesktopItem signal-desktop-bin;

  cfg = config.modules.desktop.apps.signal;
in {
  options.modules.desktop.apps.signal = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      signal-desktop-bin
    ];
  };
}
