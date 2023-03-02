# modules/browser/chromium.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.chromium;
in {
  options.modules.desktop.browsers.chromium = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      chromium
    ];
  };
}
