{ config, lib, ... }:

{
  modules.services.vaultwarden.enable = true;

  services.vaultwarden.config = {
    signupsAllowed = false;
    invitationsAllowed = true;
    domain = "https://bw.fooninja.org";
    httpPort = 8000;
    websocketEnabled = true;
    websocketPort = 8001;
  };

  # Inject secrets at runtime
  systemd.services.vaultwarden.serviceConfig = {
    EnvironmentFile = [ config.age.secrets.vaultwarden-smtp-env.path ];
    Restart = "on-failure";
    RestartSec = "2s";
  };
}
