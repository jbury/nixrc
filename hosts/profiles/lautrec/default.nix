{ ... }: {
	imports = [
		../../templates/NixosHost.nix
		./boot-configuration.nix
		./hardware-configuration.nix
		./disk-configuration.nix
	];

	config.jbury.nixrc = {
		hostSettings = {
			hostname   = "lautrec";
			hasDesktop = true;

			stateVersion = "26.05";
		};
	};
}
