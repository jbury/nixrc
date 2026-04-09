{ config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.dev.git
in {
	options.jbury.nixrc.home.modules.dev.git = {
		enable = mkEnableOption "git";
	};

	config = mkIf cfg.enable {
		programs.git = {
			enable = true;

			attributes = [
				"*.c     diff=cpp"
				"*.h     diff=cpp"
				"*.c++   diff=cpp"
				"*.h++   diff=cpp"
				"*.cpp   diff=cpp"
				"*.hpp   diff=cpp"
				"*.cc    diff=cpp"
				"*.hh    diff=cpp"
				"*.cs    diff=csharp"
				"*.css   diff=css"
				"*.html  diff=html"
				"*.xhtml diff=html"
				"*.ex    diff=elixir"
				"*.exs   diff=elixir"
				"*.go    diff=golang"
				"*.php   diff=php"
				"*.pl    diff=perl"
				"*.py    diff=python"
				"*.md    diff=markdown"
				"*.rb    diff=ruby"
				"*.rake  diff=ruby"
				"*.rs    diff=rust"
				"*.lisp  diff=lisp"
				"*.el    diff=lisp"
				"*.org   diff=org"
			];

			ignores = [
				# For emacs:
				"*~"
				"*.*~"
				"\#*"
				".\#*"

				# For vim:
				"*.swp"
				".*.sw[a-z]"
				"*.un~"
				".netrwhist"

				# OS generated files #
				######################
				".DS_Store?"
				".DS_Store"
				".CFUserTextEncoding"
				".Trash"
				".Xauthority"
				"thumbs.db"
				"Thumbs.db"
				"Icon?"
				
				# Code stuffs #
				###############
				".ccls-cache/"
				".sass-cache/"
				"__pycache__/"

				# Compiled thangs #
				###################
				"*.class"
				"*.exe"
				"*.o"
				"*.pyc"
				"*.elc"

				".gitlab-ci-local/"
				".cache/"
				"sbt-cache/"
			];
		};

		home.packages = [
			pkgs.glab
		];
	};
}
