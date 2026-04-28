## This is basically the root of _my_ home-manager profile for the jbury user.
# Does some basic home-manager configuration, and imports my home-manager modules.
{ homeSettings, ... }: {
	imports = [
		./desktop
		./dev
		./editors
		./activation
		./shell
	];

	config = {
		programs.home-manager.enable = true;

		xdg.enable = true;

		home = {
			username      = homeSettings.userName;
			homeDirectory = homeSettings.homeDirectory;
			stateVersion  = homeSettings.stateVersion;
		};
	};
}
