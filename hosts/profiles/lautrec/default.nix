{ ... }: {
	imports = [
    ../../templates/NixosHost.nix
    ./hardware-configuration.nix
    ./disk-configuration.nix
	];

	config.jbury.nixrc = {
		hostSettings = {
			hostname = "lautrec";

			stateVersion = "26.05";
		};
	};
}
