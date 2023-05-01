{ config, options, pkgs, lib, ... }:
with lib;
let cfg = config.modules.shell.flexe;
in {
  options.modules.shell.flexe = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      markdown-to-confluence
    ];
  };
}
