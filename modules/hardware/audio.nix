{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      media-session.enable = false;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;

    environment.systemPackages = [ pkgs.easyeffects ];

    user.packages = [ pkgs.easyeffects ];

    user.extraGroups = [ "audio" ];
  };
}
