{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.shell.flexe;
in {
  options.modules.shell.flexe = { enable = mkBoolOpt false; };

  config =
    mkIf cfg.enable { user.packages = with pkgs; [ markdown-to-confluence ]; };
}
