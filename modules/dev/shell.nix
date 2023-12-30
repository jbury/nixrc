# modules/dev/shell.nix --- http://zsh.sourceforge.net/
#
# How else would I do my job as a Senior YAML Engineer?

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.dev.shell;
in {
  options.modules.dev.shell = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ shellcheck checkbashisms ];
  };

}
