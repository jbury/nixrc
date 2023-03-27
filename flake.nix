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
      inputs.utils.follows = "flake-utils";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, stablepkgs, emacs-overlay, ... }:
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

      pkgs = import "${nixpkgs}" {
        inherit system;
        overlays = [
          (final: prev:{
            # Don't offend Stallman more than we need to
            slack = nonfreepkgs.slack;
            sublime4 = nonfreepkgs.sublime4;
            spotify = nonfreepkgs.spotify;
            zoom-us = nonfreepkgs.zoom-us;
            gimp = stable.gimp;
          })
          emacs-overlay.overlay
        ];
      };

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      lib = lib.my;

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShells."${system}".default = import ./shell.nix { inherit pkgs; };

    };
}
