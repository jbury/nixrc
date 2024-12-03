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
    enable = true;

    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/${schemeName}";

    fonts = {
      serif = {
        package = (pkgs.iosevka-bin.override { variant = "Etoile"; });
        name    = "Iosevka Etoile";
      };
      sansSerif = {
        package = (pkgs.iosevka-bin.override { variant = "Aile"; });
        name    = "Iosevka Aile";
      };
      monospace = {
        package = (pkgs.iosevka-bin.override { variant = "SGr-IosevkaFixed"; });
        name    = "Iosevka Term";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name    = "Noto Color Emoji";
      };

      sizes = {
        desktop = 12;
        applications = 12;
      };
    };

    image = ./desktop/wallpaper.png;
  };
}
