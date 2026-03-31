{ config, lib, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.shell.nix-index;
in {
	options.jbury.nixrc.home.modules.shell.nix-index = {
		enable = mkEnableOption "nix-index";
	};

	config.programs.nix-index = mkIf cfg.enable {
		enable = true;

		enableZshIntegration = config.jbury.nixrc.home.modules.shell.zsh.enable;
	};
}
