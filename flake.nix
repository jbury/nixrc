{
	description =
	"A gross nixos-wsl config. Approximately none incandescence to be found";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		nixpkgs-wayland = {
			url = "github:nix-community/nixpkgs-wayland";

			#TODO: Supposedly this isn't needed to prevent an extra nixpkgs eval?
			# inputs.nixpkgs.follows = "nixpkgs";
		};

		nixos-hardware.url = "github:nixos/nixos-hardware";

		nix-darwin = {
			url = "github:nix-darwin/nix-darwin/master";

			inputs.nixpkgs.follows = "nixpkgs";
		};

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

	outputs = inputs@{ self, nixpkgs, nixpkgs-wayland, nixos-wsl, nix-darwin, home-manager, emacs-overlay, stylix, ... }:
	let
		lib = nixpkgs.lib;

		jbury-lib = import ./lib {
			inherit lib;
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
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					./nix-pkgs.nix
					./hosts/profiles/gwyn
					./home/nixos-module.nix
				];
			};
			lautrec = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					./nix-pkgs.nix
					./hosts/profiles/lautrec
					./home/nixos-module.nix
				];
			};
		};

		darwinConfigurations = {
			seath = nix-darwin.lib.darwinSystem {
				specialArgs = { inherit jbury-lib inputs; };
				modules = [
					./nix-pkgs.nix
					./hosts/profiles/seath
					./home/nix-darwin-module.nix
				];
			};
		};
	};
}
