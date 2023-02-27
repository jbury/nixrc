{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.geoclue2;
in {
  options.modules.services.geoclue2 = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    services.geoclue2 = {
      enable = true;
      enableDemoAgent = true;
      appConfig = {
        "gammastep" = {
          isAllowed = true;
          isSystem = false;
          users = [];
        };
        "redshift" = {
          isAllowed = true;
          isSystem = false;
          users = [];
        };
        "org.freedesktop.DBus" = {
          isAllowed = true;
          isSystem = true;
          users = [];
        };
      };
    };
  };
}
