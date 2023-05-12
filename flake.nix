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

  outputs = inputs@{ self, nixpkgs, stablepkgs, emacs-overlay, flexe-flakes, ... }:
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

      localpackages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      pkgs = import "${nixpkgs}" {
        inherit system;
        overlays = [
          (final: prev:{
            # Don't offend Stallman more than we need to
            slack = nonfreepkgs.slack;
            sublime4 = nonfreepkgs.sublime4;
            spotify = nonfreepkgs.spotify;
            zoom-us = nonfreepkgs.zoom-us;
          })
          (final: prev:{
            # Sometimes we value stability
            gimp = stable.gimp;
          })
          (final: prev:{
            kustomize = localpackages."${system}".kustomize;
          })
          emacs-overlay.overlay
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
      #lib = lib.my;

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShells."${system}".default = import ./shell.nix { inherit pkgs; };

    };
}
