{
  description = "A gross nixos config. Approximately none incandescence to be found";

  inputs = {
    stablepkgs.url = "nixpkgs/nixos-22.11-small";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/latest";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flexe-flakes = {
      url = "path:/home/jbury/.flexe-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, stablepkgs, devenv, emacs-overlay, flexe-flakes, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      nonfreepkgs = import "${nixpkgs}" {
        inherit system;
        config.allowUnfree = true;
      };

      stable = import "${stablepkgs}" {
        inherit system;
      };

      localpackages = import ./packages {
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
      };

      pkgs = import "${nixpkgs}" {
        inherit system;
        overlays = [
          (final: prev:{
            # Don't offend Stallman more than we need to
            slack = nonfreepkgs.slack;
            sublime4 = nonfreepkgs.sublime4;
            spotify = nonfreepkgs.spotify;
            zoom-us = nonfreepkgs.zoom-us;
            terraform = nonfreepkgs.terraform;
          })
          (final: prev:{
            # Sometimes we value stability
            gimp = stable.gimp;
          })
          (final: prev:{
            # Sometimes we just want to refer to "local" packages from the packages dir
            # kustomize = localpackages.kustomize;
          })
          (final: prev:{
            devenv = devenv.packages."${system}".devenv;
          })
          flexe-flakes.overlays.default
        ];
      };

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };
    };
}
