# When I don't want to risk my disk quota being reduced by 100K

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      editorconfig-core-c
      neovim
    ];

    environment.shellAliases = {
      vim = "nvim";
    };
  };
}
