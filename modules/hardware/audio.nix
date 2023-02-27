{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
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

    environment.systemPackages = with pkgs; [
      easyeffects
    ];

    user.packages = with pkgs; [
      easyeffects
    ];

    # systemd.user.services.easyeffects = {
    #   description = "Tuning for headphones";
    #   wantedBy = [ "pipewire.service" ];
    #   after = [ "pipewire.service" ];
    #   bindsTo = [ "pipewire.service" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };

    user.extraGroups = [ "audio" ];
  };
}
