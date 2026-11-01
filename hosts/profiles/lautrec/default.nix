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
			homeStateVersion = "26.11";
    };
  };

  config.networking.interfaces = {
    wlp1s0.useDHCP = true;
  };
}
