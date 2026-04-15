{
	description =
	"A gross nixos-wsl config. Approximately none incandescence to be found";

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

	outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, emacs-overlay, stylix, ... }:
	let
		#TODO this is apparently something I can refactor away with a new pattern
		# https://github.com/NobbZ/nixos-config/pull/1387
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
						# When we want "local" packages from the packages dir
						# kustomize = localpackagesForSystem.kustomize;
					}
				)
				emacs-overlay.overlay
			];
		};
	in {
		##TODO: Commenting out for now - home-manager standalone config getting host configs is confusing.
		#homeConfigurations = {
		#	# So you can just `home-manager switch --flake ${NIXRC_DIR}`
		#	default = self.homeConfigurations.jbury.standalone;

		#	jbury = {
		#		standalone = home-manager.lib.homeManagerConfiguration {
		#			inherit pkgs;
		#			extraSpecialArgs = { inherit jbury-lib inputs; };
		#			modules = [
		#				./home
		#				stylix.homeModules.stylix
		#			];
		#		};
		#		nixos = hostSettings@{hostname, hasDesktop, stateVersion, ...}: {
		#			home-manager.lib.homeManagerConfiguration {
		#				inherit pkgs;
		#				extraSpecialArgs = {
		#					inherit jbury-lib inputs hostSettings;
		#				};
		#				modules = [
		#					./home
		#				];
		#			};
		#		};
		#	};
		#};

		nixosConfigurations = {
			gwyn = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					./hosts/profiles/gwyn
					./home/nixos-module.nix
				];
      };
      lautrec = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit jbury-lib inputs; };
        modules = [
          ./hosts/profiles/lautrec
          ./home/nixos-module.nix
        ];
      };
			oswald = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					./hosts/profiles/oswald
					./home/nixos-module.nix
				];
			};
		};
	};
}
