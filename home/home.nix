## This is basically the root of _my_ home-manager profile.
# - imports: All of my personal home-manager modules

# - config.jbury.nixrc.home.modules: Default enable settings for my personal
#                                    home-manager modules

# - config: Default home-manager setup stuff

# - options: Any global variables I need to define, on the off chance I need
#            granular control over evaluation order or something.
{ homeSettings, ... }: {
	imports = [
		./editors
		./activation
		./shell
	];

	## These are seperated out from my module enable settings because
	## these will _probably_ rarely need updating at all, and the separation
	## serves as a reminder of my original intention here (for whatever future
	## refactoring I end up doing).
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
