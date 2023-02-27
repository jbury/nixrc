{ pkgs, stdenv, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      swaywm.enable = true;
      apps = {
        slack.enable = true;
        rofi.enable = true;
        zoom.enable = true;
        # godot.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chromium.enable = true;
      };
      gaming = {
        steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
        documents.enable = true;
        documents.pdf.enable = true;
        mpv.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "alacritty";
        st.enable = false;
        alacritty.enable = true;
      };
      vm = { qemu.enable = true; };
    };
    dev = {
      cc.enable = true;
      rust.enable = true;
      cloud = {
        google.enable = true;
        # currently broken
        amazon.enable = false;
      };
      db = { postgres.enable = true; };
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    hardware = {
      audio.enable = true;
      ergodox.enable = true;
      fs = {
        enable = true;
        # zfs.enable = true;
        ssd.enable = true;
      };
      nvidia.enable = false;
      sensors.enable = true;
    };
    email = {
      mu4e.enable = true;
      mu4e.package = (pkgs.unstable.offlineimap.overrideAttrs (oa: {
        src = pkgs.fetchFromGitHub {
          owner = "OfflineIMAP";
          repo = "offlineimap";
          rev = "2d0d07cd6a0560e5845ac09a0b3fbada3a034ba6";
          sha256 = "NU/kqsBUPR+0EnEDIXMQaBU6gm2Y+KExH5XWKMFJ2x0=";
        };
      }));
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      utils.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      printing.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.domain = "fooninja.org";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;

  services.lorri.enable = true;
  services.blueman.enable = true;
  services.geoclue2.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;

  services.thermald.enable = true;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;
  services.upower.enable = true;
  services.pcscd.enable = true;
  services.tlp.enable = true;
  powerManagement.enable = true;
  # powerManagement.powertop.enable = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  programs.light.enable = true;
  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;
}
