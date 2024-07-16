{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf literalExpression;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.term.foot;
in {
  options.modules.desktop.term.foot = { enable = mkBoolOpt config.modules.desktop.swaywm.enable; };

  config = mkIf cfg.enable {
    home.programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Iosevka Term:size=12";

          dpi-aware = "yes";
        };
        bell = {
          urgent = "no";
          notify = "no";
          visual = "no";
        };
        scrollback = {
          lines = 5000;
        };
      };
    };
  };
}
