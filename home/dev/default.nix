{ ... }: {
	imports = [
		./cloud
	];

	config.home.shellAliases = {
		jqlogs = "jq -R '. as $line | try (fromjson) catch $line'";
	};
}
