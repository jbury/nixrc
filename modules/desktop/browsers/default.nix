{ config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.types) nullOr str;
  inherit (lib.my) mkOpt;

  cfg = config.modules.desktop.browsers;
in {
  options.modules.desktop.browsers = { default = mkOpt (nullOr str) null; };

  config = mkIf (cfg.default != null) { env.BROWSER = cfg.default; };
}
