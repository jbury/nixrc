{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  currentFile = "home/shell/zsh.nix";
  cfg = config.jbury.nixrc.home.modules.shell.zsh;
	#configDir = config.jbury.nixrc.dotfiles.configDir;
in {
  options.jbury.nixrc.home.modules.shell.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
  };
}
