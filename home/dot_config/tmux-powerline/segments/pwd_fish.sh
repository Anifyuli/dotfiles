# shellcheck shell=bash
# Print the current working directory in Fish shell style (last 2 dirs)

source "${TMUX_POWERLINE_DIR_LIB}/tmux_adapter.sh"

generate_segmentrc() {
	read -r -d '' rccontents <<EORC
# Fish-style path: show last 2 directory components
# Parent directories shown as initials if path is long
EORC
	echo "$rccontents"
}

run_segment() {
	tcwd=$(tp_get_tmux_cwd)
	ttcwd=${tcwd/#$HOME/\~}

	# Fish-style: abbreviate parent directories to initials
	IFS='/' read -ra parts <<< "$ttcwd"
	num_parts=${#parts[@]}

	result=""
	for ((i=0; i<num_parts; i++)); do
		part="${parts[$i]}"
		if [ -n "$part" ]; then
			# Last part: show full name
			# Parent parts: show first letter only
			if [ $i -eq $((num_parts-1)) ]; then
				result+="$part"
			else
				result+="${part:0:1}/"
			fi
		fi
	done

	echo " $result"
	return 0
}
