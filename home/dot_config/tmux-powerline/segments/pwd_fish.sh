# shellcheck shell=bash
# Print the current working directory in Fish shell style (last 2 dirs)

source "${TMUX_POWERLINE_DIR_LIB}/tmux_adapter.sh"

generate_segmentrc() {
	read -r -d '' rccontents <<EORC
# Fish-style path: show last 2 directory components
EORC
	echo "$rccontents"
}

run_segment() {
	tcwd=$(tp_get_tmux_cwd)
	ttcwd=${tcwd/#$HOME/\~}
	
	# Fish-style: show last 2 directory components
	IFS='/' read -ra parts <<< "$ttcwd"
	num_parts=${#parts[@]}
	
	if [ "$num_parts" -le 2 ]; then
		echo "$ttcwd"
	else
		# Show last 2 parts
		last_part="${parts[$((num_parts-1))]}"
		second_last="${parts[$((num_parts-2))]}"
		echo "…/${second_last}/${last_part}"
	fi
	
	return 0
}
