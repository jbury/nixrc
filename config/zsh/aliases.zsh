# Short Hands
alias sl="ls" # gottogofast

alias c="cd .."
alias cc="cd ../.."
alias ccc="cd ../../.."
alias cccc="cd ../../../.."

alias l="ls"
alias cls="clear && ls"
alias gcl="gitlab-ci-local"
alias zshrc="vim ~/.nixrc/config/zsh/"
alias rezsh="source ~/.config/zsh/.zshrc"
alias vimrc="vim ~/.vimrc"
alias sshconf="vim ~/.ssh/config"

# Nix Reloaded
alias refl="nix flake update /home/jbury/.nixrc"
alias nrf="sudo nixos-rebuild --flake /home/jbury/.nixrc/.#trusty-patches"

# CDs
alias ws="cd ~/workspace/"
alias nixrc="pushd ~/.nixrc"
alias ssw="cd ~/Pictures/Screenshots/Work"

# Flag Aliases
alias ls="ls --color -F"
alias df="df -BG"
alias grep="grep --color=never"
alias grap="grep --color=always"
alias mkdir="mkdir -pv"
alias wget="wget -c"
alias ports="netstat -tulanp"

alias jc="journalctl -e"
alias sc="systemctl"
alias ssc="sudo systemctl"

alias shutdown="sudo shutdown now"

# Sometimes I need to unplug and re-plug my mouse to actually get loonix to notice it.
alias steelseriesmouse="usb-reload 1038 1361"

autoload -U zmv

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
	local time=$1; shift
	sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched

# Why unplug it and plug it again, when I can just tell the tech support I did it?
function usb-reload {
	sudo udevadm trigger -t subsystems -c remove -s usb -a "idVendor=${1}" -a "idProduct=${2}"
	sudo udevadm trigger -t subsystems -c add -s usb -a "idVendor=${1}" -a "idProduct=${2}"
}

function reui {
	autorandr -c && reloadTheme;
}

function screens {
	DIR=$(date +"${HOME}/Pictures/Screenshots/Work/%Y/%m/%d")
	cd $DIR
}

function docker-runasme {
	local IMAGE
	local COMMAND
	local DOCKER_ACCESS
	local GITLAB_ACCESS
	local BACKUP=1

# -i IMAGE_NAME
# -c COMMAND
# -d DOCKER_ACCESS
# -g GITLAB_ACCESS
# -h HELP
	local SHORT=":i:c:hdg"

	while getopts "${SHORT}" opt; do
		case "${opt}" in
			i)
				IMAGE="${OPTARG}"
				;;
			c)
				COMMAND="${OPTARG}"
				;;
			h)
				echo "No."
				exit 2
				;;
			d)
				DOCKER_ACCESS="-v /var/run/docker.sock:/var/run/docker.sock"
				;;
			g)
				GITLAB_ACCESS="-v ~/.gitlab-token:/root/.gitlab-token"
				;;
			[?])
				BACKUP=2
				;;
		esac
	done

	if [ -z "${IMAGE}" ]; then
		echo "FATAL: Missing mandatory arg \`-i <IMAGE_NAME>\`"
		exit 1
	fi

	shift "${OPTIND}-${BACKUP}"
	local CREDS_DIR="/var/.config/gcloud/adc.json"

	local COMMAND_TO_RUN="docker run ${@} --env-file ~/.env --env GOOGLE_APPLICATION_CREDENTIALS=${CREDS_DIR} -v ~/.config/gcloud/application_default_credentials.json:${CREDS_DIR} -v ${PWD}:/var/files ${DOCKER_ACCESS} ${GITLAB_ACCESS} -w /var/files --rm -i -t ${IMAGE} ${COMMAND}"

	echo "${COMMAND_TO_RUN}"

	eval "${COMMAND_TO_RUN}"
}
alias drm="docker-runasme"

