{
  description =
    "A gross nixos config. Approximately none incandescence to be found";

  nixConfig {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes;
    use-xdg-base-directories = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager/master";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";

      inputs = {
        nixpkgs.follows      = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, emacs-overlay, stylix
    , ... }:
    let
      localPackagesForSystem = system: import ./packages {
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
      };

      pkgsForSystem = system: import "${nixpkgs}" {
        inherit system;

        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "aspell-dict-en-science"
          "terraform"
        ];

        overlays = [
          (final: prev:
            {
              # Sometimes we just want to refer to "local" packages from the packages dir
              # kustomize = localpackages.kustomize;
            }
          )
          emacs-overlay.overlay
        ]
      };

      # TODO: Having a global pkgs with a hard-coded system is not ideal for portability :(
      system = "x86_64-linux";
      pkgs = pkgsForSystem {system};

      # TODO: Extending lib like this is _not_ recommended
      lib = nixpkgs.lib.extend (final: prev: {
        my = import ./lib {
          inherit inputs;
          lib = final;
        };
      });
    in {
      nixosModules = lib.my.mapModulesRec ./modules import;

      nixosConfigurations = lib.my.mapHosts ./hosts pkgs;
    };
}
