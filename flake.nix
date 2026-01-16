{
	description =
	"A gross nixos-wsl config. Approximately none incandescence to be found";

	nixConfig = {
		auto-optimise-store = true;
		experimental-features = "nix-command flakes";
		use-xdg-base-directories = true;
		trusted-users = "@wheel";
	};

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		nixos-wsl = {
			url = "github:nix-community/NixOS-WSL/main";

			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager/master";

			inputs.nixpkgs.follows = "nixpkgs";
		};

		emacs-overlay = {
			url = "github:nix-community/emacs-overlay";

			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:nix-community/stylix";

			inputs.nixpkgs.follows = "nixpkgs";
		};

	};

	next thing needing doing is figuring out how to modularly import all my home modules, but home them all under jbury.nixrc.home.modules

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
		homeConfigurations = {
			jbury = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = { inherit jbury-lib inputs; };
				modules = [
					stylix.homeModules.stylix
					(import ./home)
				];
			};
		};	
		nixosConfigurations = {
			oswald = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					home-manager.nixosModules.home-manager
					stylix.nixosModules.stylix
					(import ./hosts/profiles/oswald)
					(import ./home)
				];
			};
		};
	};
}
