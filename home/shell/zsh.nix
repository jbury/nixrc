{ config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	currentFile = "/nixrc/home/shell/zsh.nix";
	cfg = config.jbury.nixrc.home.modules.shell.zsh;
	#configDir = config.jbury.nixrc.dotfiles.configDir;
in {
	options.jbury.nixrc.home.modules.shell.zsh = {
		enable = mkEnableOption "zsh";
	};

	config = mkIf cfg.enable {
		programs.zsh = {
			enable = true;

			envExtra = ''
				# Don't pull in any of the zsh defaults
				setopt no_global_rcs
			'';

			# Actually enables the nix-index command-not-found behaviour
			initContent = ''
				source "${pkgs.nix-index}/etc/profile.d/command-not-found.sh"
			'';
		};
	};
}
