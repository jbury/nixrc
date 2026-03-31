{ homeSettings, ... }: {
	imports = [
		./nix-index.nix
		./zsh.nix
	];

	config.jbury.nixrc.home.modules.shell = {
		zsh.enable       = true;
		nix-index.enable = true;
	};

	config.home.shellAliases = {
		gits = "git status";
		gpr = "git pull --rebase";

		c = "cd ..";
		cc = "cd ../..";
		ccc = "cd ../../..";

		l = "ls";
		cls = "clear && ls";

		nixrc = "pushd ${homeSettings.homeDirectory}/.nixrc";
		nrf = "sudo nixos-rebuild --flake ${homeSettings.homeDirectory}/.nixrc/.#${homeSettings.hostname}";
		refl = "nix flake update --flake ${homeSettings.homeDirectory}/.nixrc/";
	};
}
