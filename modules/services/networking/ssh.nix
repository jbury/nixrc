{ config, lib, ... }:

let
  inherit (lib) mkIf mkDefault;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.networking.ssh;
in {
  options.modules.services.networking.ssh = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = mkDefault "no";
      };

      startWhenNeeded = true;
      openFirewall = true;
      authorizedKeysFiles = [ ".ssh/authorized_keys" ];
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "jbury" then [ "TODO" ] else [ ];
  };
}
