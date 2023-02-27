{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.tlp;
in {
  options.modules.services.tlp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # services.tlp = {
    #   enable = true;
    #   settings = {
    #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    #   };
    # };

    # I know the module says tlp, but I'm trying this out
    services.auto-cpufreq = {
      enable = true;
    };
  };
}
