{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.podman;
in {
  options.modules.services.podman = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      fuse-overlayfs
    ];

    virtualisation = {
      podman = {
        enable = true;
      };
    };
  };
}
