{ config, lib, ... }:

let
  inherit (lib) mkDefault;
  inherit (lib.types) str;
  inherit (lib.my) mkOpt;

  cfg = config.modules.desktop.term;
in {
  options.modules.desktop.term = { default = mkOpt str "alacritty"; };

  config = {
    env.TERMINAL = cfg.default;
  };
}
