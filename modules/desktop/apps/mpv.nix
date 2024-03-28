{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.apps.mpv;
in {
  options.modules.desktop.apps.mpv = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mpv
      mpvc # CLI controller for mpv
    ];
  };
}
