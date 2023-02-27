{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "jboyens"
      then [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDECXnI34NJU+L32GB7vwdTv4R9Uv53DElOZ5T/1or7X1VJxEb2+vNjxFQm1WNru1p23Wq8vGKasjIJt20L3B2E+9A2JHuL8MDpXU5Ednk3TgR1ghSdXzqmUTWmEMuqeU7nzYtnFeEyMSpW/FLy8YxO69C3QKsJGlk6+zEMYy17EhcT87K37/Odw326yXqEG2PAyQFQuSUSUIKixjLqYdRyVUTS43PY9kFwny4XqBof+vprkSfpQJi9qbSYPTOlfdadVE4wtb0TBdHRPS9owBk09ouj3okbT4TyEgedG6QrZn5j06nAYZqI4ggAI3sKgvLaec5jwqF+mX0Jo8naV4in jr@irongiant.local" ]
      else [];
  };
}
