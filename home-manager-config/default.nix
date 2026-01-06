{ ... }: {
	imports = [
		./modules
	];

	config = {
		home-manager = {
			useGlobalPkgs = true;
			useUserPackages = true;
		};
	};
}
