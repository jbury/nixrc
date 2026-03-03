{ pkgs, ... }: {
	config = {
		environment.shells = [ pkgs.zsh ];
		users.defaultUserShell = pkgs.zsh;

		##TODO Remove if home-manager does the trick
		#programs.command-not-found.enable = false;

		programs.zsh = {
			enable = true;

			enableCompletion = true;
			# I init completion myself, because enableGlobalCompInit initializes it
			# too soon, which means commands initialized later in my config won't get
			# completion, and running compinit twice is slow.
			enableGlobalCompInit = false;

			##TODO Remove if home-manager does the trick
			#interactiveShellInit = ''
			#	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
			#'';
		};
	};
}
