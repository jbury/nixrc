{ config, pkgs, lib, homeSettings, ... }:
let
	inherit (lib) mkEnableOption mkIf;

	cfg = config.jbury.nixrc.home.modules.activation.git-keys;

in {
	options.jbury.nixrc.home.modules.activation.git-keys = {
		enable = mkEnableOption "git-keys";
	};

	config.home.activation = mkIf cfg.enable {
		generateSshDir = lib.hm.dag.entryAfter ["writeBoundary"] (
			let
				personalEmail = "2317537+jbury@users.noreply.github.com";

				personalGithubKeys = {
					pub =  "${homeSettings.homeDirectory}/.ssh/${homeSettings.userName}_github.pub";
					priv = "${homeSettings.homeDirectory}/.ssh/${homeSettings.userName}_github";
				};

				defaultGitKeys = {
					pub  = "${homeSettings.homeDirectory}/.ssh/default_git.pub";
					priv = "${homeSettings.homeDirectory}/.ssh/default_git";
				};

				ssh-keygen = "${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N \"\"";
			in ''
# Make sure ~/.ssh exists
if [ ! -d "${homeSettings.homeDirectory}/.ssh" ]; then
	mkdir "${homeSettings.homeDirectory}/.ssh"
fi

# Make sure ~/.ssh perms are correct
chmod 700 "${homeSettings.homeDirectory}/.ssh"

# Handle personal key creation
if [ ! -f "${personalGithubKeys.priv}" ]; then
	${ssh-keygen} -f "${personalGithubKeys.priv}" -C "${personalEmail}"
	chmod 600 "${personalGithubKeys.priv}"
	chmod 644 "${personalGithubKeys.pub}"
fi

# Handle default key creation or symlink
if [ ! -f "${defaultGitKeys.priv}" ]; then
	# No overriding primary homeSettings email, so this isn't a work machine
	if [ "${homeSettings.email}" == "${personalEmail}" ]; then
		ln -sf "${personalGithubKeys.pub}" "${defaultGitKeys.pub}"
		ln -sf "${personalGithubKeys.priv}" "${defaultGitKeys.priv}"
	else
		${ssh-keygen} -f "${defaultGitKeys.priv}" -C "${homeSettings.email}"
		chmod 600 "${defaultGitKeys.priv}"
		chmod 644 "${defaultGitKeys.pub}"
	fi
fi
			''
		);
	};
}
