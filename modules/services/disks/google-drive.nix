{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkDefault;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.disks.google-drive;
  configDir = config.dotfiles.configDir;
in {
  options.modules.services.disks.google-drive = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ rclone ];

    modules.shell.zsh.aliases = {
      memesdown = "rclone sync google-drive:/memes/ ~/Pictures/memes/";
      kpdown = "rclone sync --interactive google-drive:/Adult\\ Stuff/Personal.kdbx ~/";
    };
  };
}
