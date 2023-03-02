{
  description = "A gross nixos config. Approximately none incandescence to be found";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/master";

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

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, flake-utils, emacs-overlay, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      nonfreepkgs = import "${nixpkgs}" {
        inherit system;
        config.allowUnfree = true;
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
          })
          emacs-overlay.overlay
        ];
      };

      pkgs' = import "${nixpkgs-unstable}" { inherit system; };

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      overlays.default = final: prev: {
        unstable = pkgs';
        my = self.packages."${system}";
      };

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShells."${system}".default = import ./shell.nix { inherit pkgs; };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
      } // import ./templates // {
        default = self.templates.full;
      };

      apps."${system}" = {
        default = {
          type = "app";
          program = ./bin/hey;
        };
        repl = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "repl" ''
            confnix=$(mktemp)
            echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
            trap "rm $confnix" EXIT
            nix repl $confnix
          '';
        };
      };
    };
}
