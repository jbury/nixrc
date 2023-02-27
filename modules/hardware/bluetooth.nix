{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  hwCfg = config.modules.hardware;
  cfg = hwCfg.bluetooth;
in {
  options.modules.hardware.bluetooth = { enable = mkBoolOpt false; };

  config = mkMerge [
    (mkIf cfg.enable { hardware.bluetooth.enable = true; })

    (mkIf (cfg.enable && (config.services.xserver.enable
      || config.modules.desktop.swaywm.enable)) {
        services.blueman.enable = true;
      })
  ];
}
