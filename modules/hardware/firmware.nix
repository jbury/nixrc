{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  hwCfg = config.modules.hardware;
  cfg = hwCfg.firmware;
in {
  options.modules.hardware.firmware = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
    services.fwupd.extraRemotes = [ "lvfs" "dell-esrt" ];
  };
}
