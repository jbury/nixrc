{ ... }: {
	imports = [
		./desktop.nix
		./managedBoot.nix
		./managedNetwork.nix
		./managedUsers.nix
		./shell
	];
}
