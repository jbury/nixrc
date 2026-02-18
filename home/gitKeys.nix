{ config, pkgs, lib, ... }:
let
	homeSettings = config.jbury.nixrc.homeSettings;

	personalEmail = "jasondougbury@gmail.com";

	personalGithubKeys = {
		pub =  "${homeSettings.homedir}/.ssh/${homeSettings.userName}_github.pub";
		priv = "${homeSettings.homedir}/.ssh/${homeSettings.userName}_github";
	};

	defaultGitKeys = {
		pub  = "${homeSettings.homedir}/.ssh/default_git.pub";
		priv = "${homeSettings.homedir}/.ssh/default_git";
	};

in {
	config.home-manager.users.${homeSettings.userName}.home.activation = {
		generateSshDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
# Make sure ~/.ssh exists
if [ ! -d "${homeSettings.homedir}/.ssh" ]; then
	mkdir "${homeSettings.homedir}/.ssh"
fi

# Make sure ~/.ssh perms are correct
chmod 700 "${homeSettings.homedir}/.ssh"

# Handle personal key creation
if [ ! -f "${personalGithubKeys.priv}" ]; then
	${pkgs.openssl}/bin/ssh-keygen -t ed25519 -f "${personalGithubKeys.priv}" -N "${homeSettings.name}" -C "${personalEmail}"
	chmod 600 "${personalGithubKeys.priv}"
	chmod 644 "${personalGithubKeys.pub}"
	${pkgs.openssl}/bin/ssh-key add "${personalGithubKeys.pub}" --type authentication --title "${homeSettings.hostname}-personal"
	${pkgs.openssl}/bin/ssh-key add "${personalGithubKeys.pub}" --type signing --title "${homeSettings.hostname}-personal"

# Handle default key creation or symlink
if [ ! -f "${defaultGitKeys.priv}" ]; then
	# No overriding primary homeSettings email, so this isn't a work machine
	if [ "${homeSettings.email}" == "${personalEmail}" ]; then
		ln -s "${personalGithubKeys.pub}" "${defaultGitKeys.pub}"
		ln -s "${personalGithubKeys.priv}" "${defaultGitKeys.priv}"
	else
		${pkgs.openssl}/bin/ssh-keygen -t ed25519 -f "${defaultGitKeys.priv}" -N "${homeSettings.name}" -C "${homeSettings.email}"
		chmod 600 "${defaultGitKeys.priv}"
		chmod 644 "${defaultGitKeys.pub}"
		${pkgs.openssl}/bin/ssh-key add "${defaultGitKeys.pub}" --type authentication --title "${homeSettings.hostname}-default"
		${pkgs.openssl}/bin/ssh-key add "${defaultGitKeys.pub}" --type signing --title "${homeSettings.hostname}-default"
	fi
fi
		'';
	};
}
