{ ... }: {
	imports = [
		../../templates/DarwinHost.nix
	];

	config.jbury.nixrc = {
		hostSettings = {
			hostname = "seath";

			stateVersion = "26.05";
		};
	};
}
