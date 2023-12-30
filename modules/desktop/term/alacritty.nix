{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = alacritty ] && export TERM=xterm-256color
    '';

    home.configFile."alacritty" = {
      source = "${config.dotfiles.configDir}/alacritty";
      recursive = true;
    };

    user.packages = [ pkgs.alacritty ];
  };
}
