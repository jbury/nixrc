{ pkgs, ... }: {
	imports = [
		./cloud
		./ai
	];

	config = {
		home = {
			shellAliases = {
				jqlogs = "jq -R '. as $line | try (fromjson) catch $line'";
			};

			packages = [
				pkgs.devenv
			];
		};

		programs.direnv = {
			enable = true;
			enableZshIntegration = true;
		};
	};
}
