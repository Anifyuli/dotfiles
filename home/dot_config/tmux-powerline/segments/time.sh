# shellcheck shell=bash
# Prints the current time

TMUX_POWERLINE_SEG_TIME_FORMAT="${TMUX_POWERLINE_SEG_TIME_FORMAT:-%H:%M}"

run_segment() {
	if [ -n "$TMUX_POWERLINE_SEG_TIME_TZ" ]; then
		echo " $(TZ="$TMUX_POWERLINE_SEG_TIME_TZ" date +"$TMUX_POWERLINE_SEG_TIME_FORMAT")"
	else
		echo " $(date +"$TMUX_POWERLINE_SEG_TIME_FORMAT")"
	fi
	return 0
}
