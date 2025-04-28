{ inputs, config, lib, pkgs, ... }:

let
  inherit (lib.my) mkBoolOpt;

  cfg = config.nixosHost;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hostModules/home-manager.nix
    ./hostModules/hostSettings.nix
  ];

  options.nixosHost = {
    desktop = mkBoolOpt true;
    manageBoot = mkBoolOpt true;
    manageNetwork = mkBoolOpt true;
  }

  config = {
    # Packages for _every_ user to have access to - e.g. root, or steam, or whatever
    environment.systemPackages = with pkgs; [
      bind
      cached-nix-shell
      curl
      git
      gnumake
      unzip
      vim
      wget
      cacert
      nh
    ];

    boot = mkIf cfg.manageBoot {
      kernelPackages = mkDefault pkgs.linuxPackages_latest;

      loader = {
        systemd-boot = {
          enable = mkDefault true;
          configurationLimit = 5;
          editor = false;
        };
        efi = {
          canTouchEfiVariables = mkDefault true;
          efiSysMountPount = "/boot";
        };
      };
    };

    networking = mkIf cfg.manageNetwork {
      useDHCP = mkDefault true;
      enableIPv6 = mkDefault true;
      useNetworkd = mkDefault true;
      nameservers = mkDefault [];
      nftables.enable = mkDefault true;

      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 80 443 ];
        allowedTCPPortRanges = [ { from = 8080; to = 8090; } ];

        allowedUDPPorts = [
          #DHCPv6
          546
        ];
        allowedUDPPortRanges = [];
      };
    };

    system.configurationRevision = mkIf (inputs.self ? inputs.rev) inputs.self.rev;
    system.stateVersion = "25.05";
  }
}
