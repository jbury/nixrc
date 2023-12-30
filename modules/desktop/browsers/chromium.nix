{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.browsers.chromium;
in {
  options.modules.desktop.browsers.chromium = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = [ pkgs.chromium ]; };
}
