{
  description =
    "A gross nixos-wsl config. Approximately none incandescence to be found";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, emacs-overlay, stylix, ... }:
    let
      system = "x86_64-linux";

      localpackages = import ./packages {
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
      };

      pkgs = import "${nixpkgs}" {
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
            })
          inputs.emacs-overlay.overlay
        ];
      };
    in {
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.11";
              wsl = {
                enable = true;
                defaultUser = "jbury";
                wslConf = {
                  interop.enabled = false;
                  interop.appendWindowsPath = false;
                  network.hostname = "oswald";
                };
              };
            }
          ];
        }
      };
    };
}
