{ config, pkgs, lib, inputs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.stylix;
  oldScheme = "tokyo-city-terminal-dark.yaml";
  schemeName = "tokyodark-terminal.yaml";
in {
  options.modules.stylix = { enable = mkBoolOpt false; };

  imports = [ inputs.stylix.nixosModules.stylix ];

  config.stylix = mkIf cfg.enable {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${schemeName}";
    image = ./desktop/core/wallpaper.png;
  };
}
