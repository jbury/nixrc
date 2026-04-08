#!/usr/bin/env zsh

# Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
if [[ "${TERM}" == "dumb" || -n "${INSIDE_EMACS}" ]]; then
	unsetopt zle prompt_cr prompt_subst
	whence -w precmd >/dev/null && unfunction precmd
	whence -w preexec >/dev/null && unfunction preexec
	PS1='$ '
fi

## Bootstrap interactive sessions
if [[ "${TERM}" != "dumb" ]]; then
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

	# Source our remaining config files
	source "${ZCONFDIR}/plugins.zsh"
	source "${ZCONFDIR}/completion.zsh"
	source "${ZCONFDIR}/keybinds.zsh"
	source "${ZCONFDIR}/functions.zsh"
	source "${ZCONFDIR}/prompt.zsh"

	# If you have host-local configuration, put it here
	if [ -f "${ZDOTDIR}/local.zsh" ]; then
		source "${ZDOTDIR}/local.zsh"
	fi
fi
