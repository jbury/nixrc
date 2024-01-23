{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) makeDesktopItem signal-desktop;

  cfg = config.modules.desktop.apps.discord;
in {
  options.modules.desktop.apps.discord= { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.discord
    ];
  };
}
