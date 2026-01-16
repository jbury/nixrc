{ config, ... }:
let
	homeSettings = config.jbury.nixrc.homeSettings;
in{
	imports = [
		./editors
	];

	config.users.${homeSettings.userName} = {
		home.stateVersion = homeSettings.stateVersion;

	}
}
