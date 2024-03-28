{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) writeScriptBin rofi stdenv;

  cfg = config.modules.desktop.core.rofi;
in {
  options.modules.desktop.core.rofi = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      (writeScriptBin "rofi" ''
        #!${stdenv.shell}
        exec ${rofi}/bin/rofi "$@"
      '')
    ];
  };
}
