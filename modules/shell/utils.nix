{ config, options, pkgs, lib, ... }:
with lib;
let cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # Networking
      bind
      iw
      mtr
      openssl

      # Basic utils
      bat
      eza
      fd
      jq
      envsubst
      file
      lsof
      libnotify
      ripgrep
      tldr
      tree
      zip
      unzip
      wl-clipboard-x11
      yq-go
    ];
  };
}
