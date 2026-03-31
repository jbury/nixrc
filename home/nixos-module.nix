## This is the nixos module that _wraps_ the home-manger configuration
## (which lives in home.nix).  Confusing?  Yeah, but I've not yet thought
## of a better way.  Maybe when I find a use for standalone home-manager?
{ inputs, config, pkgs, ... }:
let
	homeSettings = (
		let
			hostSettings = config.jbury.nixrc.hostSettings;
		in {
			userName      = hostSettings.userName;
			homeDirectory = "/home/${hostSettings.userName}";
			email         = hostSettings.email;
			hostname      = hostSettings.hostname;
			hasDesktop    = hostSettings.hasDesktop;
			stateVersion  = hostSettings.stateVersion;
		}
	);
in {
	imports = [
		inputs.home-manager.nixosModules.home-manager {
			home-manager = {
				useGlobalPkgs   = true;
				useUserPackages = true;
				#startAsUserService = true;

				users.${homeSettings.userName}.imports = [ ./home.nix ];
				extraSpecialArgs = { inherit homeSettings; };
			};
		}

		inputs.stylix.nixosModules.stylix
		./stylix.nix
	];

	#For now
	#config.users.users.${homeSettings.userName}.shell = pkgs.zsh;
}
