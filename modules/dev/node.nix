# modules/dev/node.nix --- https://nodejs.org/en/
#
# Only if you pay me.

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkIf;
  inherit (lib.my) mkBoolOpt;

  devCfg = config.modules.dev;
  cfg = devCfg.node;
in {
  options.modules.dev.node = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = [ pkgs.nodejs_latest pkgs.yarn ];

      # Run locally installed bin-script, e.g. n coffee file.coffee
      environment.shellAliases = {
        n = ''PATH="$(${pkgs.nodejs_latest}/bin/npm bin):$PATH"'';
        ya = "yarn";
      };

      env.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];
    })

    (mkIf (cfg.enable && cfg.xdg.enable) {
      env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      env.NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
      env.NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      env.NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
      env.NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";

      home.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
    })
  ];
}
