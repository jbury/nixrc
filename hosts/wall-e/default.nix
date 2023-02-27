{ modulesPath, pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      swaywm.enable = true;
      i3.enable = false;
      apps = {
        bitwarden.enable = true;
        slack.enable = true;
        zoom.enable = true;
        maestral.enable = true;
        waybar.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chromium.enable = true;
      };
      media = {
        documents.enable = true;
        documents.pdf.enable = true;
        mpv.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "foot";
        foot.enable = true;
      };
      vm = { qemu.enable = false; };
    };
    dev = {
      android.enable = false;
      cc.enable = true;
      rust.enable = true;
      go.enable = true;
      node.enable = true;
      cloud = {
        enable = true;
        google.enable = true;
      };
      db = { postgres.enable = true; };
      ruby.enable = true;
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      ergodox.enable = true;
      nvidia.enable = false;
      sony-1000Xm3.enable = true;
      fs = {
        enable = true;
        # zfs.enable = true;
        ssd.enable = true;
      };
      sensors.enable = true;
    };
    email = {
      mu4e.enable = true;
      mu4e.package = pkgs.unstable.offlineimap;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      utils.enable = true;
      vaultwarden.enable = true;
      weechat.enable = false;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      # mpd.enable = true;
      podman.enable = false;
      printing.enable = true;
      geoclue2.enable = true;
      tlp.enable = true;
      restic = {
        enable = true;
        backups = {
          workspace.enable = true;
          home.enable = true;
          mail.enable = true;
        };
      };
      syncthing.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "nord";
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.useNetworkd = true;

  systemd.network.networks = let
    networkConfig = {
      DHCP = "yes";
      Domains = "fooninja.org";
    };
  in {
    "39-wired" = {
      enable = true;
      name = "en*";
      inherit networkConfig;
      dhcpV4Config = {
        RouteMetric = 10;
      };
    };
    "40-wireless" = {
      enable = true;
      name = "wl*";
      inherit networkConfig;
      dhcpV4Config = {
        RouteMetric = 20;
      };
    };
  };

  systemd.network.wait-online.extraArgs = [ "--any" ];

  networking.wireless.iwd.enable = true;

  networking.domain = "fooninja.org";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;

  # Strict reverse path filtering breaks Tailscale exit node use and some subnet
  # routing setups.
  networking.firewall.checkReversePath = "loose";

  services.lorri.enable = false;
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;

  services.atd.enable = true;
  services.tailscale.enable = true;
  services.thermald.enable = true;
  services.thermald.package = pkgs.my.thermald;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;
  services.upower.enable = true;
  services.pcscd.enable = true;
  powerManagement.enable = true;
  # powerManagement.powertop.enable = true;

  services.ananicy.enable = true;
  services.ananicy.package = pkgs.ananicy-cpp;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;
  services.earlyoom.enableDebugInfo = false;

  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;

  gtk.iconCache.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    wlr.settings = {
      screencast = {
        output_name = "DP-4";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
}
