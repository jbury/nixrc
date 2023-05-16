{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my; {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);


  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
  in {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    nixPath = nixPathInputs ++ [
      "dotfiles=${config.dotfiles.dir}"
    ];
    registry = registryInputs // { dotfiles.flake = inputs.self; };
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "22.11";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so we enforce
  # this default behavior here.
  networking.useDHCP = mkDefault true;

  # A root fileSystem is needed to appease the nix flake check gods
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

  home-manager.useGlobalPkgs = true;

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        configurationLimit = 5;
        enable = mkDefault true;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  # It's dangerous to pull yourself up by your bootstraps alone, take these:
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
  ];
}
