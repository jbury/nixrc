# Misc Bin - things that should be something/somewhere else

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
	local time=$1; shift
	sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched

alias rezsh="source ~/.config/zsh/.zshrc" #TODO: why in god's name...? Was there a reason not to just exec zsh?  Maybe login shell memes or some such?  Probably something to care about when I get back to a desktop env.
alias cleanzsh="find ${HOME}/.config/zsh -type f -name '*.zwc' -delete"
