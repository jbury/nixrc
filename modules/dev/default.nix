{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev;
in {
  options.modules.dev = {
    enable = mkBoolOpt true;
    xdg.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable { user.packages = [ pkgs.devenv ]; };
}
