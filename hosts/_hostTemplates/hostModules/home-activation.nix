{ config, pkgs, lib, ... }: let
	#TODO: Someday actually break this out to something someone else might be able to use
	defaultIdentity = {
		name = "Jason Bury";
		email = "jasondougbury@gmail.com";
	};

	personalGithubKeys = {
		pub =  "~/.ssh/${config.hostSettings.userName}_github.pub";
		priv = "~/.ssh/${config.hostSettings.userName}_github";
	};

	defaultGitKeys = {
		pub  = "~/.ssh/default_git.pub";
		priv = "~/.ssh/default_git";
	};

	hostCfg = config.hostModules.hostSettings;
in {

	# Sets the right perms on ~/ and sets up needed initial git keys
	generateSshDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
# Make sure ~/.ssh perms are correct
if [ -d "~/.ssh" ]; then
	chmod 700 "~/.ssh"
fi

# Handle personal key creation
if [ ! -f "${personalGithubKeys.priv}" ]; then
	${pkgs.openssl}/bin/ssh-keygen -t ed 25519 -f "${personalGithubKeys.priv}" -N "${defaultIdentity.name}" -C "${defaultIdentity.email}"
	chmod 600 "${personalGithubKeys.priv}"
	chmod 644 "${personalGithubKeys.pub}"
	${pkgs.openssl}/bin/ssh-key add "${personalGithubKeys.pub}" --type authentication --title "${hostCfg.hostName}-personal"
	{pkgs.openssl}/bin/ssh-key add "${personalGithubKeys.pub}" --type signing --title "${hostCfg.hostName}-personal"

# Handle default key creation or symlink
if [ ! -f "${defaultGitKeys.priv}" ]; then
	# No overriding primary hostSettings email, so this isn't a work machine
	if [ "${hostCfg.email}" == "${defaultIdentity.email}" ]; then
		ln -s "${personalGithubKeys.pub}" "${defaultGitKeys.pub}"
		ln -s "${personalGithubKeys.priv}" "${defaultGitKeys.priv}"
	else
		${pkgs.openssl}/bin/ssh-keygen -t ed 25519 -f "${defaultGitKeys.priv}" -N "${defaultIdentity.name}" -C "${hostCfg.email}"
		chmod 600 "${defaultGitKeys.priv}"
		chmod 644 "${defaultGitKeys.pub}"
		${pkgs.openssl}/bin/ssh-key add "${defaultGitKeys.pub}" --type authentication --title "${hostCfg.hostName}-default"
		${pkgs.openssl}/bin/ssh-key add "${defaultGitKeys.pub}" --type signing --title "${hostCfg.hostName}-default"
	fi
fi
	'';

}
