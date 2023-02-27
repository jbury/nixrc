{ pkgs, stdenv, lib, inputs, ... }: {
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
        # 2022-10-26 - Broken again on Python 3.10 dbus-next
        maestral.enable = true;
        signal-desktop.enable = true;
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
      vm = { qemu.enable = true; };
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
      solokeys.enable = true;
      sony-1000Xm3.enable = true;
      firmware.enable = true;
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
        enable = false;
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
    theme.active = "base16";
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  services.prometheus.exporters.node = {
    enable = false;
    openFirewall = true;
    enabledCollectors = [ "systemd" ];
  };

  # networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.powersave = false;
  # networking.networkmanager.wifi.backend = "iwd";

  networking.useNetworkd = true;

  systemd.network.networks = let
    networkConfig = {
      DHCP = "yes";
      Domains = "fooninja.org";
    };
  in {
    "90-wireless" = {
      enable = true;
      name = "wl*";
      inherit networkConfig;
    };

    "70-wired" = {
      enable = true;
      name = "en*";
      networkConfig = {
        inherit (networkConfig) Domains;
        DHCP = "yes";
      };

      dhcpV4Config.RouteMetric = 10;
      ipv6AcceptRAConfig.RouteMetric = 10;
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

  services.pipewire.enable = true;

  services.atd.enable = true;
  services.tailscale.enable = true;
  services.pcscd.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/135888
  services.nscd.enableNsncd = true;

  services.nfs.idmapd.settings = {
    General = { Domain = "fooninja.org"; };

    Translation = { GSS-Methods = "static,nsswitch"; };

    Static = { "jboyens@fooninja.org" = "jboyens"; };
  };

  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;

  gtk.iconCache.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
