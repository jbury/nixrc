# modules/dev/java.nix
#
# Jarva

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.java;
in {
  options.modules.dev.java = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      openjdk17
      (kotlin.override { jre = pkgs.openjdk17; })
      jetbrains.idea-community
      maven
    ];

    # Because I guess we can't have nice things by default in Java.
    # Maybe nice things aren't backwards compatible?
    env._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";

    # Otherwise Java application popups are FULL SCREEN APPLICATIONS
    env._JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
