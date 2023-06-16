{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev;
in {
  options.modules.dev = {
    enable = mkBoolOpt true;
    xdg.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      certbot
      devenv
    ];
  };
}
