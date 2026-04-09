{ homeSettings, ... }: {
	imports = [
		./git
		./zsh
	];

	config.jbury.nixrc.home.modules.shell = {
		git.enable = true;
		zsh.enable = true;
	};

	config.home.shellAliases = {
		# Short Hands
		sl = "ls"; # gottagofast

		c = "cd ..";
		cc = "cd ../..";
		ccc = "cd ../../..";
		cccc = "cd ../../../..";

		l = "ls";
		cls = "clear && ls";
		whitespace = "sed 's/ /·/g;s/\t/￫/g;s/$/¶/g'";

		# Nix Reloaded
		refl = "nix flake update --flake /nixrc/";
		nrf = "sudo nixos-rebuild --flake /nixrc/.#${homeSettings.hostname}";
		nixgc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";

		# CDs
		ws = "cd ${homeSettings.homeDirectory}/workspace/";
		nixrc = "cd /nixrc/";
		sshconf = "vim ${homeSettings.homeDirectory}/.ssh/config";

		# Flag 'Em Down
		ls = "ls --color -F";
		df = "df -BG";
		grep = "grep --color=never";
		grap = "grep --color=always";
		mkdir = "mkdir -pv";
		ports = "ss -tulanp";

		jc  = "journalctl -e";
		sc  = "systemctl";
		ssc = "sudo systemctl";

		shutdown = "sudo shutdown now";

		xargs = "xargs "; # This is the dumbest most batshit insane thing I've ever seen
# Since aliases are recursive, making xargs an alias causes all other aliased commands to automatically expand
# which means xargs now respects my aliases.
	};
}
