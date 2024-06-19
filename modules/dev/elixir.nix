# modules/dev/elixir.nix
#
# My potions are too powerful for you, traveller.

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.elixir;
in {
  options.modules.dev.elixir = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      elixir-ls
    ];
  };
}
