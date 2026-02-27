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
	};
}
