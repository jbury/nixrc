{ config, lib, homeSettings, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.shell.zsh;

	zdotdir  = "${config.xdg.configHome}/zsh";
	zconfdir = "${zdotdir}/confs";
in {
	options.jbury.nixrc.home.modules.shell.zsh = {
		enable = mkEnableOption "zsh";
	};

	config = mkIf cfg.enable {

		xdg.configFile."zsh/confs" = {
			source    = ./confs;
			recursive = true;
			force     = true;
		};

		programs.zsh = {
			enable = true;

			# Content added to the generated .zshrc file
			initContent = ''source "${zconfdir}/config.zsh"'';

			shellAliases = {
				cleanzsh = "find ${zdotdir} -type f -name '*.zwc' -delete";
				rezsh    = "exec zsh";
			};

			setOptions = [
				"NO_GLOBAL_RCS"       # Don't pull in any of the zsh package default RC files
				"NO_BRACE_CCL"        # Allow brace character class list expansion
				"COMBINING_CHARS"     # Combine zero-length punc chars (accents) with base char
				"RC_QUOTES"           # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
				"HASH_LIST_ALL"
				"NO_CORRECT_ALL"
				"NO_NOMATCH"
				"NO_MAIL_WARNING"     # Don't print a warning if a mail file has been accessed.
				"NO_BEEP"             # Hust now, quiet now.
				"IGNOREEOF"
				"HIST_REDUCE_BLANKS"  # Minimize unnecessary whitespace

				## Jobs
				"LONG_LIST_JOBS"  # List jobs in the long format by default
				"AUTO_RESUME"     # Attempt to resume existing job before creating a new process
				"NOTIFY"          # Report status of background jobs immediately
				"NO_BG_NICE"      # Don't run all background jobs at a lower priority
				"NO_HUP"          # Don't kill jobs on shell exit
				"NO_CHECK_JOBS"   # Don't report on jobs when shell exit

				## Directories
				"NO_AUTO_CD"         # Implicit CD slows down plugins
				"CDABLE_VARS"        # Change directory to a path stored in a variable
				"MULTIOS"            # Write to multiple descriptors
				"EXTENDED_GLOB"      # Use extended globbing syntax
				"NO_GLOB_DOTS"
				"NO_AUTO_NAME_DIRS"  # Don't add variable-stored paths to the ~ list
			];

			localVariables = {
				DIRSTACKSIZE = "9";
				WORDCHARS = "_-*?[]~&.;!#$%^(){}<>";
				ZCONFDIR = "${zconfdir}";
			};

			history = {
				append = true;
				expireDuplicatesFirst = true;
				extended = true;
				ignoreAllDups = true;
				ignoreSpace = true;
				saveNoDups = true;
				share = true;

				path = "${config.xdg.dataHome}/zsh/zsh_history";
				size = 100000;
				save = 100000;
			};

			syntaxHighlighting.enable = true;
			# I init compinit myself in prompt.zsh, which also manages my caching.
			completionInit = "";
			defaultKeymap = "emacs";
		};


# Generating this database is slow as hell on some machines, and it's not really critical, feature-wise, for me.
#		programs.nix-index = {
#			enable = true;
#			enableZshIntegration = true;
#		};
	};
}
