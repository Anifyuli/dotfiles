# shellcheck shell=bash
# Prints the current time

TMUX_POWERLINE_SEG_TIME_FORMAT="${TMUX_POWERLINE_SEG_TIME_FORMAT:-%H:%M}"

run_segment() {
	if [ -n "$TMUX_POWERLINE_SEG_TIME_TZ" ]; then
		TZ="$TMUX_POWERLINE_SEG_TIME_TZ" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT"
	else
		date +"$TMUX_POWERLINE_SEG_TIME_FORMAT"
	fi
	return 0
}
