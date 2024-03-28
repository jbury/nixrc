{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.apps.graphics;
in {
  options.modules.desktop.apps.graphics = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      imagemagick # for image manipulation from the shell
      inkscape # replaces illustrator & indesign
      gimp # replaces photoshop
    ];
  };
}
