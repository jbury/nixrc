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
	${pkgs.openssl}/bin/ssh-key add "${personalGithubKeys.pub}" --type authentication --title "${config.hostSettings.hostName}-personal"
	{pkgs.openssl}/bin/ssh-key add "${personalGithubKeys.pub}" --type signing --title "${config.hostSettings.hostName}-personal"

# Handle default key creation or symlink
if [ ! -f "${defaultGitKeys.priv}" ]; then
	# No overriding primary hostSettings email, so this isn't a work machine
	if [ "${config.hostSettings.email}" == "${defaultIdentity.email}" ]; then
		ln -s "${personalGithubKeys.pub}" "${defaultGitKeys.pub}"
		ln -s "${personalGithubKeys.priv}" "${defaultGitKeys.priv}"
	else
		${pkgs.openssl}/bin/ssh-keygen -t ed 25519 -f "${defaultGitKeys.priv}" -N "${defaultIdentity.name}" -C "${config.hostSettings.email}"
		chmod 600 "${defaultGitKeys.priv}"
		chmod 644 "${defaultGitKeys.pub}"
		${pkgs.openssl}/bin/ssh-key add "${defaultGitKeys.pub}" --type authentication --title "${config.hostSettings.hostName}-default"
		${pkgs.openssl}/bin/ssh-key add "${defaultGitKeys.pub}" --type signing --title "${config.hostSettings.hostName}-default"
	fi
fi
  '';
}
