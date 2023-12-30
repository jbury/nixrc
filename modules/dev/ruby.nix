# modules/dev/ruby.nix
#
# Sometimes you just can't be bothered to rewrite the whole thing from scratch _again_.

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.ruby;
in {
  options.modules.dev.ruby = { enable = mkBoolOpt false; };

  config =
    mkIf cfg.enable { user.packages = with pkgs; [ ruby_2_7 solargraph ]; };
}
