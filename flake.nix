{
  description =
    "A gross nixos config. Approximately none incandescence to be found";

  inputs = {
    nixpkgs.url = "nixpkgs/master";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-compat = {
      url   = "github:edolstra/flake-compat";
      flake = false;
    };

    nix-eval-jobs = {
      url = "github:nix-community/nix-eval-jobs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";


      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";

      inputs = {
        nixpkgs.follows       = "nixpkgs";
        flake-compat.follows  = "flake-compat";
        lib-aggregate.follows = "lib-aggregate";
        nix-eval-jobs.follows = "nix-eval-jobs";
      };
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";

      inputs = {
        nixpkgs.follows     = "nixpkgs";
      };
    };

    stylix = {
      url = "github:danth/stylix";

      inputs = {
        nixpkgs.follows      = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-compat.follows = "flake-compat";
      };
    };

    # cachix stuff
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";

      inputs = {
        nixpkgs.follows        = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-compat.follows   = "flake-compat";
      };
    };

    devenv = {
      url = "github:cachix/devenv/latest";

      inputs = {
# devenv uses a custom build of nix, `nix-devenv`, which follows the nixpkgs input, but applies
# some now out-of-date patches to the boehm-gc dependency.  For details, see:
# https://github.com/cachix/devenv/issues/1200#issuecomment-2112452403
#        nixpkgs.follows          = "nixpkgs";

        flake-compat.follows     = "flake-compat";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };
  };

  outputs = inputs@{ self, nixpkgs, devenv, stylix, emacs-overlay
    , ... }:
    let
      inherit (lib.my) mapModulesRec mapHosts;

      system = "x86_64-linux";

      localpackages = import ./packages {
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
      };

      pkgs = import "${nixpkgs}" {
        inherit system;

        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "aspell-dict-en-science"
          "discord"
          "slack"
          "spotify"
          "sublime4"
          "terraform"
#          "zoom-us" https://discourse.nixos.org/t/suggested-pattern-for-using-allowunfreepredicate-is-overly-permissive-due-to-overloaded-pnames/47609
          "zoom"
        ];

        overlays = [
          (final: prev:
            {
              # Sometimes we just want to refer to "local" packages from the packages dir
              # kustomize = localpackages.kustomize;
              remontoire = localpackages.remontoire;
            })
          (final: prev: { devenv = devenv.packages."${system}".devenv; })
          inputs.emacs-overlay.overlay
          # Only tested for unstable channel
          # inputs.nixpkgs-wayland.overlay
        ];
      };

      lib = nixpkgs.lib.extend (final: prev: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = final;
        };
      });
    in {
      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };
    };
}
