{ homeSettings, ... }: {
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

		nixrc = "pushd ${homeSettings.homeDirectory}/.nixrc";
		nrf = "sudo nixos-rebuild --flake ${homeSettings.homeDirectory}/.nixrc/.#$(hostname)";
		refl = "nix flake update --flake ${homeSettings.homeDirectory}/.nixrc/";
	};
}
