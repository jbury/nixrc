{ ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    stylix.enable = true;

    desktop = {
      core = {
        rofi.enable = true;
        bspwm.enable = true;
      };
      apps = {
        discord.enable = true;
        slack.enable = true;
        signal.enable = true;
        zoom.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        spotify.enable = true;
      };
      browsers = {
        default = "firefox";
        chromium.enable = true;
        firefox.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      extras = {
        screensnap.enable = false;
        setup.enable = false;
      };
    };
    dev = {
      cloud.enable = true;
      cloud.google.enable = true;
      go.enable = true;
      java.enable = true;
      shell.enable = true;
      db.postgres.enable = true;
    };
    editors = {
      emacs.enable = true;
      vim.enable = true;
    };
    shell = {
      direnv.enable = true;
      flexe.enable = true;
      git = {
        enable = true;
        gitlab.enable = true;
      };
      utils.enable = true;
      zsh.enable = true;
    };

    services = { docker.enable = true; };
  };
}
