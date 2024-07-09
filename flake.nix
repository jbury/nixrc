{
  description =
    "A gross nixos config. Approximately none incandescence to be found";

  inputs = {
    stablepkgs.url = "nixpkgs/nixos-23.11-small";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/latest";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, stablepkgs, devenv, stylix, emacs-overlay
    , ... }:
    let
      inherit (lib.my) mapModulesRec mapHosts;

      system = "x86_64-linux";

      stable = import "${stablepkgs}" { inherit system; };

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
        ] ;

        overlays = [
          (final: prev: {
            # Sometimes we value stability
            # gimp = stable.gimp;
          })
          (final: prev:
            {
              # Sometimes we just want to refer to "local" packages from the packages dir
              # kustomize = localpackages.kustomize;
              remontoire = localpackages.remontoire;
              vanta-agent = localpackages.vanta-agent;
            })
          (final: prev: { devenv = devenv.packages."${system}".devenv; })
          inputs.emacs-overlay.overlay
          inputs.nixpkgs-wayland.overlay
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
