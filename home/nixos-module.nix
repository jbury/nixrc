## This is the nixos module that _wraps_ the home-manger configuration
## (which lives in home.nix).  Confusing?  Yeah, but I've not yet thought
## of a better way.
{ inputs, config, ... }:

let
	hostSettings = config.jbury.nixrc.hostSettings;

	homeSettings = {
		userName     = hostSettings.userName;
		hostname     = hostSettings.hostname;
		hasDesktop   = hostSettings.hasDesktop;
		stateVersion = hostSettings.stateVersion;
	};
in {
	imports = [
		inputs.home-manager.nixosModules.home-manager {
			home-manager = {
				useGlobalPkgs = true;

				users.${homeSettings.userName}.imports = [ ./home.nix ];
				extraSpecialArgs = { config.jbury.nixrc.homeSettings = homeSettings; };
			};
		}
	];
}
