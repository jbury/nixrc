# modules/dev/ruby.nix
#
# Sometimes you just can't be bothered to rewrite the whole thing from scratch _again_.

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.ruby;
in {
  options.modules.dev.ruby = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ruby_2_7
      solargraph
    ];

    # environment.shellAliases = {
    # };
  };
}
