# modules/dev/android.nix
#

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.android;
in {
  options.modules.dev.android = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    user.extraGroups = [ "adbusers" ];
    services.udev.packages = [ pkgs.android-udev-rules ];
  };
}
