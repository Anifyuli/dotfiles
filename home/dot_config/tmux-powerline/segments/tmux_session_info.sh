# shellcheck shell=bash
# Prints tmux session info

run_segment() {
	local session
	session=$(tmux display-message -p '#S')
	echo "${session}"
	return 0
}
