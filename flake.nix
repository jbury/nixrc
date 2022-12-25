{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      nonfreepkgs = import "${nixpkgs}" {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import "${nixpkgs}" {
        inherit system;
        overlays = [ (final: prev:{
            slack = nonfreepkgs.slack;
            sublime4 = nonfreepkgs.sublime4;
            spotify = nonfreepkgs.spotify;
        }) ];
      };

    in {
      homeConfigurations.jbury = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
    };
}
