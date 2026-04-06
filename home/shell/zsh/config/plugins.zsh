#!/usr/bin/env zsh

## Bootstrap zgenom
# Don't let zgenom call compinit - it does it too early
export ZGEN_AUTOLOAD_COMPINIT=0

export ZGEN_DIR="${ZGEN_DIR:-${XDG_DATA_HOME:-~/.local/share}/zgenom}"
if [[ ! -d "${ZGEN_DIR}" ]]; then
	# Use zgenom because zgen is no longer maintained
	echo "Installing jandamm/zgenom"
	git clone https://github.com/jandamm/zgenom "${ZGEN_DIR}"
fi
source "${ZGEN_DIR}/zgenom.zsh"

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

if ! zgenom saved; then
	echo "Initializing zgenom"
	rm -frv \
		${ZDOTDIR}/*.zwc(N) \
		${ZDOTDIR}/.*.zwc(N) \
		${XDG_CACHE_HOME}/zsh \
		${ZGEN_INIT}.zwc

	# NOTE Be extra careful about plugin load order, or subtle breakage can
	#   emerge. This is the best order I've sussed out for these plugins.
	zgenom load zdharma-continuum/fast-syntax-highlighting
	zgenom load zsh-users/zsh-completions src
	zgenom load zsh-users/zsh-autosuggestions
	zgenom load zsh-users/zsh-history-substring-search
	zgenom load romkatv/powerlevel10k powerlevel10k

	zgenom save
	zgenom compile "${ZDOTDIR}"
fi
