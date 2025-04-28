{ inputs, config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkDefault filterAttrs mapAttrsToList mapAttrs;
  inherit (builtins) toString;
  inherit (lib.my) mapModulesRec';
in {
  imports = [
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
    nixPath = nixPathInputs ++ [ "dotfiles=${config.dotfiles.dir}" ];
    registry = registryInputs // { dotfiles.flake = inputs.self; };
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };
}
