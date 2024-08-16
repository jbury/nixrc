# Temp
alias kill-signal="pgrep -l signal | head -n1 | cut -d' ' -f1 | xargs kill -9 "

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
alias dm="datamash"
alias vimrc="vim ~/.vimrc"
alias sshconf="vim ~/.ssh/config"
alias alsa="alsamixer"

# Nix Reloaded
alias refl="nix flake update /home/jbury/.nixrc"
alias nrf="sudo nixos-rebuild --flake /home/jbury/.nixrc/.#knight-lautrec"

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

alias jqlogs="jq -R '. as $line | try (fromjson) catch $line'"

alias shutdown="sudo shutdown now"

alias keys="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\n\", $5, $8 }'"

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

function nixgc {
	nix-collect-garbage -d
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

	local VALID_FLAG_FOUND=$(false)

	while getopts "${SHORT}" opt; do
		case "${opt}" in
			i)
				IMAGE="${OPTARG}"
				VALID_FLAG_FOUND=$(true)
				;;
			c)
				COMMAND="${OPTARG}"
				VALID_FLAG_FOUND=$(true)
				;;
			h)
				echo "No."
				return 2
				;;
			d)
				DOCKER_ACCESS="-v /var/run/docker.sock:/var/run/docker.sock"
				VALID_FLAG_FOUND=$(true)
				;;
			g)
				GITLAB_ACCESS="-v ~/.gitlab-token:/root/.gitlab-token"
				VALID_FLAG_FOUND=$(true)
				;;
			[?])
				if $VALID_FLAG_FOUND; then
					BACKUP=2
				else
					echo "Invalid input - need to specify image with -i and command with -c"
				fi
				;;
		esac
	done

	if [ -z "${IMAGE}" ]; then
		echo "FATAL: Missing mandatory arg \`-i <IMAGE_NAME>\`"
		return 1
	fi

	shift "${OPTIND}-${BACKUP}"
	local CREDS_DIR="/var/.config/gcloud/adc.json"

	local COMMAND_TO_RUN="docker run ${@} --env-file ~/.env --env GOOGLE_APPLICATION_CREDENTIALS=${CREDS_DIR} -v ~/.config/gcloud/application_default_credentials.json:${CREDS_DIR} -v ${PWD}:/var/files ${DOCKER_ACCESS} ${GITLAB_ACCESS} -w /var/files --rm -i -t ${IMAGE} ${COMMAND}"

	echo "${COMMAND_TO_RUN}"

	eval "${COMMAND_TO_RUN}"
}
alias drm="docker-runasme"

alias cleanzsh="find ${HOME}/.config/zsh -type f -name '*.zwc' -delete"
alias showscreens="feh * -."

alias xargs='xargs ' # This is the dumbest most batshit insane thing I've ever seen
# Since aliases are recursive, making xargs an alias causes all other aliased commands to automatically expand
# which means xargs now respects my aliases.

pow () {
	local BAT_NAME="BAT1"
	local BAT_CAP
	BAT_CAP=$(tr -d '\n' < "/sys/class/power_supply/${BAT_NAME}/capacity")
	local BAT_STATUS
	BAT_STATUS=$(tr -d '\n' < "/sys/class/power_supply/${BAT_NAME}/status")
	if [ "$BAT_STATUS" = "Discharging" ]
	then
		echo "${BAT_CAP}-"
	else
		echo "${BAT_CAP}+"
	fi
}
