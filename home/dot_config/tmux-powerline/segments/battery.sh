# shellcheck shell=bash
# Prints battery - compact filled blocks only

run_segment() {
	if tp_shell_is_macos; then
		battery_status=$(__battery_macos)
	else
		battery_status=$(__battery_linux)
	fi
	
	if [ -z "$battery_status" ]; then
		echo " AC"
		return
	fi

	perc=$(echo "$battery_status" | grep -o '[0-9]*' | head -1)

	if [ -n "$perc" ]; then
		echo " ${perc}%"
	fi
}

__battery_linux() {
	local total_full=0
	local total_now=0

	while read -r bat; do
		local full="$bat/charge_full"
		local now="$bat/charge_now"

		if [ ! -r "$full" ]; then
			full="$bat/energy_full"
		fi
		if [ ! -r "$now" ]; then
			now="$bat/energy_now"
		fi

		if [ -r "$full" ] && [ -r "$now" ]; then
			local bf bn
			bf=$(cat "$full")
			bn=$(cat "$now")
			total_full=$((total_full + bf))
			total_now=$((total_now + bn))
		fi
	done <<<"$(grep -l "Battery" /sys/class/power_supply/*/type | sed -e 's,/type$,,')"

	if [ "$total_full" -gt 0 ]; then
		if [ "$total_now" -gt "$total_full" ]; then
			total_now=$total_full
		fi
		echo "$((100 * total_now / total_full))"
	fi
}

__battery_macos() {
	ioreg -c AppleSmartBattery -w0 |
		grep -o '"[^"]*" = [^ ]*' |
		sed -e 's/= //g' -e 's/"//g' |
		sort |
		while read -r key value; do
			case $key in
			"MaxCapacity") maxcap=$value ;;
			"CurrentCapacity") curcap=$value ;;
			esac
			if [[ -n $maxcap && -n $curcap ]]; then
				echo $((100 * curcap / maxcap))
				break
			fi
		done
}
