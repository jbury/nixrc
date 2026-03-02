## This is the home-manager configuration module that will configure a home-manager user the way _I_ like it.
{ homeSettings, ... }: {
	imports = [
		./editors
		./activation
	];

	config = {
		jbury.nixrc.home.modules = {
			editors = {
				vim.enable = true;
			};
		};

		home = {
			username      = homeSettings.userName;
			homeDirectory = homeSettings.homeDirectory;
			stateVersion  = homeSettings.stateVersion;
		};

		programs.home-manager.enable = true;

		xdg.enable = true;
	};
}
