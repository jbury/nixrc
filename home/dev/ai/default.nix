{ pkgs, ... }: {
	imports = [
		./claude.nix
	];

	config.jbury.nixrc.home.modules.dev.ai = {
		claude.enable = true;
	};

	config.programs = {
	};

	config.home.packages = with pkgs; [
	];
}
