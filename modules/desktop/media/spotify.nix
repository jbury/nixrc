# I use spotify for my music needs. Gone are the days where I'd manage 200gb+ of
# local music; most of which I haven't heard or don't even like.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.spotify;
in {
  options.modules.desktop.media.spotify = {
    enable = mkBoolOpt false;
    tui.enable = mkBoolOpt false;  # TODO
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      spotify
    ];
  };
}
