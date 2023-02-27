# modules/dev/db.nix
#
# Packages for various cloud services
{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.dev.db;
in {
  options.modules.dev.db = {
    postgres.enable = mkBoolOpt false;
    mysql.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.postgres.enable {
      user.packages = with pkgs; [ postgresql pgcenter ];
    })

    (mkIf cfg.mysql.enable {
      user.packages = with pkgs; [ mysql ];
    })
  ];
}
