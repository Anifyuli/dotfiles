# shellcheck shell=bash
# Print the current date with year

TMUX_POWERLINE_SEG_DATE_FORMAT="${TMUX_POWERLINE_SEG_DATE_FORMAT:-%d/%m/%Y}"

run_segment() {
	date +"$TMUX_POWERLINE_SEG_DATE_FORMAT"
	return 0
}
