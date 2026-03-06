{ ... }: {
	imports = [
		./nix-index.nix
		./zsh.nix
	];

	config.home.shellAliases = {
		gits = "git status";
		gpr = "git pull --rebase";

		c = "cd ..";
		cc = "cd ../..";
		ccc = "cd ../../..";

		l = "ls";
		cls = "clear && ls";

		nixrc = "pushd \${HOME}/.nixrc";
		nrf = "nixos-rebuild --flake \${HOME}/.nixrc/.#$(hostname)";
		refl = "nix flake update --flake \${HOME}/.nixrc/";
	};
}
