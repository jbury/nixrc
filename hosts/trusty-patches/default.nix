{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = true;
      apps = {
        rofi.enable   = true;
        slack.enable  = true;
        signal.enable = true;
        zoom.enable   = true;
      };
      browsers = {
        default         = "firefox";
        chromium.enable = true;
        firefox.enable  = true;
      };
      media = {
        graphics.enable = true;
        mpv.enable      = true;
        spotify.enable  = true;
      };
      term = {
        default          = "alacritty";
        alacritty.enable = true;
      };
    };
    dev = {
      cc.enable           = true;
      cloud.enable        = true;
      cloud.google.enable = true;
      go.enable           = true;
      java.enable         = true;
      shell.enable        = true;
      db.postgres.enable  = true;
    };
    editors = {
      emacs.enable = true;
      vim.enable   = true;
    };
    shell = {
      git.enable   = true;
      gnupg.enable = true;
      utils.enable = true;
      zsh.enable   = true;
    };
    services = {
      docker.enable = true;
    };
    theme.active = "alucard";
  };
}
