{ config, lib, ... }:

let
  inherit (lib) mkDefault;
  inherit (lib.types) str;
  inherit (lib.my) mkOpt;

  cfg = config.modules.desktop.term;
in {
  options.modules.desktop.term = { default = mkOpt str "xterm"; };

  config = {
    services.xserver.desktopManager.xterm.enable =
      mkDefault (cfg.default == "xterm");

    env.TERMINAL = cfg.default;
  };
}
