{ ... }: {
	imports = [
		./cloud
	];

	config.jbury.nixrc.home.modules.dev = {
	};

	config.home.shellAliases = {
		jqlogs = "jq -R '. as $line | try (fromjson) catch $line'";
	};
}
