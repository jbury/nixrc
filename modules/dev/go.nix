# modules/dev/go.nix
#
# Go?  More like GO AWAY lolol gotem

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.go;
in {
  options.modules.dev.go = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      go
      gopls
      gocode
      gore
      gotools
      gotests
      gomodifytags
      golangci-lint
      delve
    ];
  };
}
