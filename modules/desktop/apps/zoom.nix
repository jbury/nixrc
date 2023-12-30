{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.apps.zoom;
in {
  options.modules.desktop.apps.zoom = { enable = mkBoolOpt false; };

  config =
    mkIf cfg.enable { user.packages = [ pkgs.zoom-us pkgs.pulseaudio ]; };
}
