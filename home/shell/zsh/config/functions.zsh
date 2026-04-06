# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
	local time=$1; shift
	sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched
