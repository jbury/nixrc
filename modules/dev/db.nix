# modules/dev/db.nix
#
# Packages for various db memes

{ config, lib, pkgs, ... }:
let
  inherit (lib) mkMerge mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.db;
in {
  options.modules.dev.db = {
    postgres.enable = mkBoolOpt false;
    mysql.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.postgres.enable {
      user.packages = with pkgs; [ postgresql pgcenter ];
    })

    (mkIf cfg.mysql.enable { user.packages = with pkgs; [ mysql ]; })
  ];
}
