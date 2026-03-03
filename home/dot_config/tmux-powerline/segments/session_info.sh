# shellcheck shell=bash
# Prints tmux session info (Session:Window:Pane)

generate_segmentrc() {
	read -r -d '' rccontents <<EORC
# Session info format
export TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="${TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT:-#S:#I:#P}"
EORC
	echo "$rccontents"
}

run_segment() {
	local format="${TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT:-#S:#I:#P}"
	local result
	result=$(tmux display-message -p -F "$format")
	echo "$result"
	return 0
}
