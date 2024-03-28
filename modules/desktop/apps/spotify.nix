# I use spotify for my music needs. Gone are the days where I'd manage 200gb+ of
# local music; most of which I haven't heard or don't even like.

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.apps.spotify;
in {
  options.modules.desktop.apps.spotify = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ spotify ]; };
}
