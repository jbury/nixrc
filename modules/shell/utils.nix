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
      # for calculations
      bc

      # for watching networks
      bwm_ng

      # for guessing mime-types
      file

      # for checking out block devices
      hdparm

      # for checking in on block devices
      iotop

      # for understanding who has what open
      lsof

      # for running commands repeatedly
      unstable.entr

      # for downloading things rapidly
      axel

      # for monitoring
      unstable.bottom

      # for json parsing
      unstable.jq

      # for yaml parsing
      yq-go

      # for pretty du
      unstable.du-dust

      # dig
      bind

      # sound
      pavucontrol
      pamixer

      # network
      mtr

      # zips
      unzip

      # certs/keys
      openssl

      # wireless
      iw

      # notify-send
      libnotify

      wl-clipboard-x11

      envsubst
    ];
  };
}
