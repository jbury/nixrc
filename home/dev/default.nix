{ ... }: {
	imports = [
		./cloud
		./git.nix
	];

	config.jbury.nixrc.home.modules.dev = {
		git.enable = true;
	};

	config.home.shellAliases = {
		jqlogs = "jq -R '. as $line | try (fromjson) catch $line'";
	};
}
