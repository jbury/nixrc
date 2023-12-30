# modules/dev/go.nix
#
# Go?  More like GO AWAY lolol gotem

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.go;
in {
  options.modules.dev.go = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      go
      gopls
      gocode
      gore
      gotools
      gotests
      goreleaser
      gomodifytags
      golangci-lint
      delve
    ];
  };
}
