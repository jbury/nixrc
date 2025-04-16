{... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

#  settings = {
#    username = "jbury";
#    email = "jasondougbury@gmail.com";
#    gitroot = "jbury";
#    sensors = {
#      cpu_temp = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
#      battery = "BAT1";
#    };
#  };

  networking.hostName = "oswald"; # Define your hostname.

  ## Modules
  modules = {
    dev = {
      cloud.enable = true;
      cloud.aws.enable = true;
      cloud.azure.enable = true;
      go.enable = true;
      shell.enable = true;
      db.postgres.enable = true;
    };
    editors = {
      emacs.enable = true;
      vim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      utils.enable = true;
      zsh.enable = true;
    };
    services = {
      docker.enable = true;
      disks = {
        google-drive.enable = true;
      };
    };
    stylix.enable = true;
  };
}
