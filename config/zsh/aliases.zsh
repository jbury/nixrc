# Short Hands
alias sl="ls" # gottogofast

alias c="cd .."
alias cc="cd ../.."
alias ccc="cd ../../.."
alias cccc="cd ../../../.."

alias l="ls"
alias cls="clear && ls"
alias gcl="gitlab-ci-local"
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias sshconf="vim ~/.ssh/config"
alias kc="kubectl"
alias k="kubectl"
alias kccc="kubectl config current-context"
alias tfdiff="jq '.resource_changes[] | select(.change.actions | index(\"no-op\") | not)'"

# Nix Reloaded
alias reflake="nix flake update /home/jbury/.nixrc/flake.nix"
alias nrf="sudo nixos-rebuild --flake /home/jbury/.nixrc/.#trusty-patches"

# CDs
alias ws="cd ~/workspace/"
alias nixrc="cd ~/.nixrc"

# Flag Aliases
alias ls="ls --color -F"
alias df="df -BG"
alias grep="grep --color=never"
alias grap="grep --color=always"
alias mkdir="mkdir -pv"
alias wget="wget -c"
alias ports="netstat -tulanp"

alias y="xclip -selection clipboard -in"
alias p="xclip -selection clipboard -out"

alias jc="journalctl -xe"
alias sc="systemctl"
alias ssc="sudo systemctl"

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
  autorandr && ~/.config/bspwm/bspwmrc && reloadTheme;
}
