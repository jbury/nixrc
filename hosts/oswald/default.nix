{ ... }: {
imports = [
	../WslHost.nix
];

hostModules.hostSettings = {
	email             = "jason.bury@docusign.com";
	home.stateVersion = "25.05";
};

## Modules
modules = {
	dev = {
		cloud.enable = true;
		cloud.aws.enable = true;
		cloud.azure.enable = true;
		cloud.gcp.enable = true;
		go.enable = true;
		shell.enable = true;
	};
	editors = {
		emacs.enable = true;
		vim.enable = true;
	};
	shell = {
		direnv.enable = true;
		git.enable = true;
		zsh.enable = true;
	};
	services = {
		docker.enable = true;
	};
	stylix.enable = true;
};}
