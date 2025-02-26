{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # Networking
      bind
      iw
      mtr
      openssl

      # Basic utils
      bat
      datamash
      eza
      fd
      jq
      envsubst
      file
      lsof
      libnotify
      linuxKernel.packages.linux_latest_libre.perf
      ripgrep
      tldr
      tree
      zip
      unzip
      wl-clipboard-x11
      yq-go

      # Pretty shell scripts
      gum
    ];
  };
}
