# modules/dev/shell.nix --- http://zsh.sourceforge.net/
#
# How else would I do my job as a Senior YAML Engineer?

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.shell;
in {
  options.modules.dev.shell = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        shellcheck
        checkbashisms
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
