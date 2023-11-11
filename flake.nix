{
  description = "A very basic flake that pulls in home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = "jbury";
      system = "x86_64-linux";

      nonfreepkgs = import "${nixpkgs}" {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs = import "${nixpkgs}" {
        inherit system;
        overlays = [
          (final: prev:{
            # Don't just allowUnfree globally - override the specific unfree packages we actually want.
            slack = nonfreepkgs.slack;
          })
        ];
      };

    in {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit username;

        modules = [
          ./home.nix
        ];
      };
    };
}
