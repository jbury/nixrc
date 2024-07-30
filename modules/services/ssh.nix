{ config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.my) mkBoolOpt;

  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
      authorizedKeysFiles = [ ".ssh/authorized_keys" ];
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "jbury" then [ "TODO" ] else [ ];
  };
}
