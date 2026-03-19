{ ... }: {
	imports = [
		./vim.nix
	];

	config.jbury.nixrc.home.modules.editors = {
		vim.enable = true;
	};
}
