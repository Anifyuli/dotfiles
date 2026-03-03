# shellcheck shell=bash
# Prints current VCS branch

run_segment() {
	local branch
	branch=$(git -C "$(pwd)" rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [ -n "$branch" ]; then
		echo "± ${branch}"
	fi
	return 0
}
