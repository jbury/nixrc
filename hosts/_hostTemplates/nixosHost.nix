{ inputs, config, lib, pkgs, ... }:

let
  inherit (lib.my) mkBoolOpt;

  cfg = config.nixosHost;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hostModules/home-manager.nix
    ./hostModules/hostSettings.nix
    ./hostModules/networking.nix
    ./hostModules/boot.nix
  ];

  options.nixosHost = {
    desktop       = mkBoolOpt true;
    manageNetwork = mkBoolOpt true;
    manageBoot    = mkBoolOpt true;
  }

  config = {
    host.manageNetwork = cfg.manageNetwork;
    host.manageBoot    = cfg.manageBoot;

    # Packages for _every_ user to have access to - e.g. root, or steam, or whatever
    environment.systemPackages = with pkgs; [
      bat
      bind
      cacert
      cached-nix-shell
      curl
      datamash
      envsubst
      eza
      fd
      file
      git
      gnumake
      gnupg
      gum
      jq
      lsof
      nh
      openssl
      ripgrep
      tldr
      tree
      unzip
      vim
      wget
      yq-go
    ];

    system.configurationRevision = mkIf (inputs.self ? inputs.rev) inputs.self.rev;
  }
}
