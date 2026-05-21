{ homeSettings, config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.shell.git;
in {
	options.jbury.nixrc.home.modules.shell.git = {
		enable = mkEnableOption "git";
	};

	config = mkIf cfg.enable {
		programs.git = {
			enable = true;

			settings = {
				user = {
					name  = homeSettings.userName;
					email = homeSettings.email;
				};
				advice = {
					skippedCherryPicks = "false";
				};
				alias = {
					uncommit = "reset --soft HEAD~1";
					restore-file = "checkout HEAD --";
					get = "!f() { git clone -v git@github.com:jbury/$1; }; f";
					outta-here = "!echo https://www.youtube.com/watch?v=BHkfdZjshqY&t=34s";
					gud = "!cat $XDG_STATE_HOME/git/giantdad.txt";
				};
				branch = {
					sort = "-committerdate";
				};
				column = {
					ui = "auto";
				};
				commit = {
					#TODO: when gpg
					# gpgSign = "true";
				};
				diff = {
					algorithm = "histogram";

					"org" = {
						xfuncname = "^(\\*+ +.*)$";
					};
				};
				fetch = {
					prune = "true";
					pruneTags = "true";
				};
				filter = {
					"tabspace2" = {
						smudge = "unexpand --tabs=2 --first-only";
						clean = "expand --tabs=2 --initial";
					};
					"tabspace4" = {
						smudge = "unexpand --tabs=4 --first-only";
						clean = "expand --tabs=4 --initial";
					};
				};
				init = {
					defaultBranch = "main";
				};
				protocol = {
					version = "2";
				};
				pull = {
					rebase = "true";
					twohead = "ort";
				};
				push = {
					default = "current";
					autoSetupRemote = "true";
				};
				rebase = {
					autoSquash = "true";
					autoStash = "true";
				};
				rerere = {
					enabled = "true";
					autoupdate = "1";
				};
				tag = {
					sort = "-version:refname";
					#TODO: when gpg
					#gpgSign = "true";
				};
				url = {
					"ssh://git@gitlab.com:" = {
						insteadOf = "https://gitlab.com";
#						insteadOf = "gitlab.com";
					};
					"ssh://git@github.com:" = {
						insteadOf = "https://github.com";
#						insteadOf = "github.com/";
					};
				};
			};

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

		home.shellAliases = {
			gl   = "git log --graph --pretty=\"format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset\"";
			gll  = "git log --pretty=\"format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset\"";
			gpr  = "git pull --rebase --autostash";
			gs   = "git status --short .";
			gits = "git status";
		};

		home.packages = [
			pkgs.glab
		];

		# This makes me giggle
		xdg.stateFile."git/giantdad.txt".source = ./giantdad.txt;

		xdg.configFile."zsh/git-stata.zsh".source = ./stata.zsh;
		#TODO: Figure out how this is supposed to work to get stata goin'
		#programs.zsh.siteFunctions = {
		#	stata = '''';
		#};
	};
}
