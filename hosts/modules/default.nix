{ ... }: {
	imports = [
		./desktop.nix
		./docker.nix
		./managedBoot.nix
		./managedNetwork.nix
		./managedUsers.nix
		./shell
	];
}
