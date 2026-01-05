{
	description =
	"A gross nixos-wsl config. Approximately none incandescence to be found";

	nixConfig = {
		auto-optimise-store = true;
		experimental-features = "nix-command flakes";
		use-xdg-base-directories = true;
	};

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

		lib = nixpkgs.lib;

		jbury-lib = import ./lib {
			inherit lib;
		};

		localPackages = import ./packages {
			inherit lib;
			pkgs = nixpkgs.legacyPackages.${system};
		};
      
		pkgs = import nixpkgs {
			inherit system;

			config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
				"aspell-dict-en-science"
				"terraform"
			];

			overlays = [
				(final: prev:
					{
						# Sometimes we just want to refer to "local" packages from the packages dir
						# kustomize = localpackagesForSystem.kustomize;
					}
				)
				emacs-overlay.overlay
			];
		};
	in {
		nixosConfigurations = {
			oswald = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					(import ./hosts/oswald)
					(import ./modules)
				];
			};
		};
	};
}
