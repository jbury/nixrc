{... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

#  settings = {
#    username = "jbury";
#    email = "jason@knock.app";
#    sensors = {
#      cpu_temp = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
#      battery = "BAT1";
#    };
#  };

  networking.hostName = "knight-lautrec"; # Define your hostname.

  ## Modules
  modules = {
    hardware = {
      audio.enable = true;
      thermald.enable = false;
    };
    desktop = {
      swaywm.enable = true;
      apps = {
        rofi.enable = true;
        slack.enable = true;
        signal.enable = true;
        zoom.enable = true;
      };
      browsers = {
        firefox.enable = true;
      };
      media = {
        graphics.enable = true;
        mpv.enable = true;
        spotify.enable = true;
      };
    };
    dev = {
      cloud.enable = true;
      cloud.aws.enable = true;
      elixir.enable = true;
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
      vanta-agent.enable = true;

      networking = {
        tailscale = {
          enable = true;
          hostname = "jason-framework";
        };
      };
    };
    stylix.enable = true;
  };
}
