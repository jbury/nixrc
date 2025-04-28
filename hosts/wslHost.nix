{ config, lib, ... }:
# Default settings to use for all WSL hosts, including mapping my hostSettings to
# the relevant nixos-wsl config options.

let
  inherit (lib.types) str;
  inherit (lib.my) mkOpt;

  cfg = config.wslHost;
  hostcfg = config.hostSettings;
in {
  imports = [
    nixos-wsl.nixosModules.default
    ./nixosHost.nix
  ];

  options.wslHost = {
    user     = mkOpt str hostcfg.userName;
    hostname = mkOpt str hostcfg.hostName;

    interop.enable = mkBoolOpt false;
  };

  config = {
    nixosHost = {
      desktop = false;
      manageBoot = false;
      manageNetwork = false;
    };

    wsl = {
      enable = true;
      defaultUser = cfg.user;
      wslConfg = {
        interop.enabled = cfg.interop.enable;
        interop.appendWindowsPath = cfg.interop.enable;
        network.hostname = cfg.hostname;
    };
  };
}
