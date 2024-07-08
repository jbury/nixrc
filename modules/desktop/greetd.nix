{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.greetd;
in {
  options.modules.desktop.greetd = { enable = mkBoolOpt config.modules.desktop.swaywm.enable; };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd sway
        '';
      };
    };

    environment.etc."greetd/environments".text = ''
      sway
    '';
  };
}
