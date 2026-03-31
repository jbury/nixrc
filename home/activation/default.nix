{ ... }: {
	imports = [
		./git-keys.nix
	];

	config.jbury.nixrc.home.modules.activation = {
		git-keys.enable = false;
	};
}
