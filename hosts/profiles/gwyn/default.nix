{ ... }: {
	imports = [
#		./hardware-configuration.nix
		../../templates/WslHost.nix
	];

	config.jbury.nixrc = {
		hostSettings = {
			hostname = "gwyn";

			stateVersion = "26.05";
		};
	};
}
