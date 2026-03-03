{ ... }: {
	imports = [
		./managedBoot.nix
		./managedNetwork.nix
		./managedUsers.nix
		./shell
	];
}
