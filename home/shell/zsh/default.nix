{ config, lib, pkgs, ... }:

let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.shell.zsh;
in {
	options.jbury.nixrc.home.modules.shell.zsh = {
		enable = mkEnableOption "zsh";
	};

	config = mkIf cfg.enable {
		programs.zsh = {
			enable = true;

			envExtra = ''
# Don't pull in any of the zsh defaults
setopt no_global_rcs

# Allow some kinda cool dotenv-esque behaviours
if [[ -f "${HOME}/.env" ]]; then
	set -o allexport
	source "${HOME}/.env"
	set +o allexport
fi

# Be more restrictive with permissions; no one has any business reading things
# that don't belong to them.
if (( EUID != 0 )); then
	umask 027
else
	# Be even less permissive if root.
	umask 077
fi
'';
		};

		programs.nix-index = {
			enable = true;
			enableZshIntegration = true;
		};
	};
}
