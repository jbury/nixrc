{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;
  inherit (pkgs) gparted arandr;

  cfg = config.modules.desktop.extras.setup;
in {
  options.modules.desktop.extras.setup = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [
      gparted # Partitioning is hard without a gui
      arandr  # Beautiful xrandr GUI layout tool for generating monitor layout configs
    ];
  };
}
