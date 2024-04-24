{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop;
in {
  config = {
    user.packages = with pkgs; [
      xdg-utils # This is the way

      feh # Basic image viewer
      keepassxc # Password manager of my dreams
      xclip # Copy/Paste, screenshots, etc.
    ];

    modules.shell.zsh.aliases.y = "xclip -selection clipboard -in";
    modules.shell.zsh.aliases.p = "xclip -selection clipboard -out";

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        iosevka-bin
        (iosevka-bin.override { variant = "Etoile"; })
        (iosevka-bin.override { variant = "Aile"; })
        (iosevka-bin.override { variant = "SGr-IosevkaFixed"; })

        noto-fonts-emoji

        fira
        fira-code
        fira-mono
      ];

      fontconfig.defaultFonts = {
        serif = [ "Iosevka Etoile" ];
        sansSerif = [ "Iosevka Aile" ];
        monospace = [ "Iosevka Term" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
