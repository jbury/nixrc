# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
	local time=$1; shift
	sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched

# Only works on a machine that actually has a battery though.
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
