{ ... }: {
	imports = [
		../../templates/WslHost.nix
	];

	config.security.pki.certificates = [
		(builtins.readFile ./zs_ssl.crt)
	];

	config.jbury.nixrc = {
		hostSettings = {
			hostname = "oswald";

			stateVersion = "25.11";
		};

		### Modules
		#modules = {
		#	dev = {
		#		cloud.enable = true;
		#		cloud.aws.enable = true;
		#		cloud.azure.enable = true;
		#		cloud.gcp.enable = true;
		#		go.enable = true;
		#		shell.enable = true;
		#	};
		#	editors = {
		#		emacs.enable = true;
		#		vim.enable = true;
		#	};
		#	shell = {
		#		direnv.enable = true;
		#		git.enable = true;
		#		zsh.enable = true;
		#	};
		#	services = {
		#		docker.enable = true;
		#	};
		#	stylix.enable = true;
		#};
	};
}
