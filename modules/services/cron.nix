{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.cron;
    configDir = config.dotfiles.configDir;
in {
  options.modules.services.cron = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.cron = {
      enable = true;
      systemCronJobs = [
        "*/15 * * * *      jbury   . etc/static/profiles/per-user/jbury; work_screenshot &>> /tmp/cron.log"
      ];
    };
  };
}
