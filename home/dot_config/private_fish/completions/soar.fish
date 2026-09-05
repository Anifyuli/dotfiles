# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_soar_global_optspecs
    string join \n v/verbose q/quiet j/json no-color no-progress p/profile= c/config= P/proxy= H/header= A/user-agent= 4/ipv4 6/ipv6 S/system h/help V/version
end

function __fish_soar_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_soar_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_soar_using_subcommand
    set -l cmd (__fish_soar_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c soar -n "__fish_soar_needs_command" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_needs_command" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_needs_command" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_needs_command" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_needs_command" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_needs_command" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_needs_command" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_needs_command" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_needs_command" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_needs_command" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_needs_command" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_needs_command" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_needs_command" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_needs_command" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_needs_command" -s V -l version -d 'Print version'
complete -c soar -n "__fish_soar_needs_command" -f -a "config" -d 'Print the configuration file to stdout'
complete -c soar -n "__fish_soar_needs_command" -f -a "install" -d 'Install packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "i" -d 'Install packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "add" -d 'Install packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "search" -d 'Search package'
complete -c soar -n "__fish_soar_needs_command" -f -a "s" -d 'Search package'
complete -c soar -n "__fish_soar_needs_command" -f -a "find" -d 'Search package'
complete -c soar -n "__fish_soar_needs_command" -f -a "query" -d 'Query package info'
complete -c soar -n "__fish_soar_needs_command" -f -a "Q" -d 'Query package info'
complete -c soar -n "__fish_soar_needs_command" -f -a "remove" -d 'Remove packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "r" -d 'Remove packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "del" -d 'Remove packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "sync" -d 'Sync with remote metadata'
complete -c soar -n "__fish_soar_needs_command" -f -a "S" -d 'Sync with remote metadata'
complete -c soar -n "__fish_soar_needs_command" -f -a "fetch" -d 'Sync with remote metadata'
complete -c soar -n "__fish_soar_needs_command" -f -a "update" -d 'Update packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "u" -d 'Update packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "upgrade" -d 'Update packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "info" -d 'Show info about installed packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "list-installed" -d 'Show info about installed packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "list" -d 'List all available packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "ls" -d 'List all available packages'
complete -c soar -n "__fish_soar_needs_command" -f -a "log" -d 'Inspect package build log'
complete -c soar -n "__fish_soar_needs_command" -f -a "inspect" -d 'Inspect package build script'
complete -c soar -n "__fish_soar_needs_command" -f -a "run" -d 'Run packages without installing to PATH'
complete -c soar -n "__fish_soar_needs_command" -f -a "exec" -d 'Run packages without installing to PATH'
complete -c soar -n "__fish_soar_needs_command" -f -a "execute" -d 'Run packages without installing to PATH'
complete -c soar -n "__fish_soar_needs_command" -f -a "use" -d 'Use package from different family'
complete -c soar -n "__fish_soar_needs_command" -f -a "download" -d 'Download arbitrary files'
complete -c soar -n "__fish_soar_needs_command" -f -a "dl" -d 'Download arbitrary files'
complete -c soar -n "__fish_soar_needs_command" -f -a "health" -d 'Health check'
complete -c soar -n "__fish_soar_needs_command" -f -a "defconfig" -d 'Generate default config'
complete -c soar -n "__fish_soar_needs_command" -f -a "repo" -d 'Manage repositories'
complete -c soar -n "__fish_soar_needs_command" -f -a "repository" -d 'Manage repositories'
complete -c soar -n "__fish_soar_needs_command" -f -a "env" -d 'View env'
complete -c soar -n "__fish_soar_needs_command" -f -a "plugin-manifest" -d 'Print how a frontend should drive this soar'
complete -c soar -n "__fish_soar_needs_command" -f -a "url" -d 'Act on a soar:// link, or register soar as its handler'
complete -c soar -n "__fish_soar_needs_command" -f -a "clean" -d 'Garbage collection'
complete -c soar -n "__fish_soar_needs_command" -f -a "self" -d 'Modify the soar installation'
complete -c soar -n "__fish_soar_needs_command" -f -a "apply" -d 'Apply declarative package configuration'
complete -c soar -n "__fish_soar_needs_command" -f -a "defpackages" -d 'Generate default packages configuration'
complete -c soar -n "__fish_soar_needs_command" -f -a "completions" -d 'Generate shell completions'
complete -c soar -n "__fish_soar_needs_command" -f -a "json2db" -d 'Convert JSON metadata to SQLite database'
complete -c soar -n "__fish_soar_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand config" -s e -l edit -d 'Open the configuration file in editor Optional value can be passed to set as editor (default is $EDITOR)' -r
complete -c soar -n "__fish_soar_using_subcommand config" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand config" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand config" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand config" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand config" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand config" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand config" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand config" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand config" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand config" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand config" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand config" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand config" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand config" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand install" -l portable -d 'Set portable dir for home & config' -r -F
complete -c soar -n "__fish_soar_using_subcommand install" -l portable-home -d 'Set portable home' -r -F
complete -c soar -n "__fish_soar_using_subcommand install" -l portable-config -d 'Set portable config' -r -F
complete -c soar -n "__fish_soar_using_subcommand install" -l portable-share -d 'Set portable share' -r -F
complete -c soar -n "__fish_soar_using_subcommand install" -l portable-cache -d 'Set portable cache' -r -F
complete -c soar -n "__fish_soar_using_subcommand install" -l name -d 'Override package name (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand install" -l version -d 'Override version (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand install" -l pkg-type -d 'Override package type (for URL installs, e.g., appimage, flatimage, archive)' -r
complete -c soar -n "__fish_soar_using_subcommand install" -l pkg-id -d 'Override package ID (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand install" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand install" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand install" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand install" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand install" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand install" -s f -l force -d 'Whether to force install the package'
complete -c soar -n "__fish_soar_using_subcommand install" -s y -l yes -d 'Skip all prompts and use first'
complete -c soar -n "__fish_soar_using_subcommand install" -l no-notes -d 'Don\'t display notes'
complete -c soar -n "__fish_soar_using_subcommand install" -l binary-only -d 'Exclude log, build/spec files, and desktop integration files'
complete -c soar -n "__fish_soar_using_subcommand install" -s a -l ask -d 'Ask for confirmation before installation'
complete -c soar -n "__fish_soar_using_subcommand install" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand install" -l show -d 'Show all available variants for interactive selection'
complete -c soar -n "__fish_soar_using_subcommand install" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand install" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand install" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand install" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand install" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand install" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand install" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand install" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c soar -n "__fish_soar_using_subcommand i" -l portable -d 'Set portable dir for home & config' -r -F
complete -c soar -n "__fish_soar_using_subcommand i" -l portable-home -d 'Set portable home' -r -F
complete -c soar -n "__fish_soar_using_subcommand i" -l portable-config -d 'Set portable config' -r -F
complete -c soar -n "__fish_soar_using_subcommand i" -l portable-share -d 'Set portable share' -r -F
complete -c soar -n "__fish_soar_using_subcommand i" -l portable-cache -d 'Set portable cache' -r -F
complete -c soar -n "__fish_soar_using_subcommand i" -l name -d 'Override package name (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand i" -l version -d 'Override version (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand i" -l pkg-type -d 'Override package type (for URL installs, e.g., appimage, flatimage, archive)' -r
complete -c soar -n "__fish_soar_using_subcommand i" -l pkg-id -d 'Override package ID (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand i" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand i" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand i" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand i" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand i" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand i" -s f -l force -d 'Whether to force install the package'
complete -c soar -n "__fish_soar_using_subcommand i" -s y -l yes -d 'Skip all prompts and use first'
complete -c soar -n "__fish_soar_using_subcommand i" -l no-notes -d 'Don\'t display notes'
complete -c soar -n "__fish_soar_using_subcommand i" -l binary-only -d 'Exclude log, build/spec files, and desktop integration files'
complete -c soar -n "__fish_soar_using_subcommand i" -s a -l ask -d 'Ask for confirmation before installation'
complete -c soar -n "__fish_soar_using_subcommand i" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand i" -l show -d 'Show all available variants for interactive selection'
complete -c soar -n "__fish_soar_using_subcommand i" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand i" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand i" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand i" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand i" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand i" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand i" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand i" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand i" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c soar -n "__fish_soar_using_subcommand add" -l portable -d 'Set portable dir for home & config' -r -F
complete -c soar -n "__fish_soar_using_subcommand add" -l portable-home -d 'Set portable home' -r -F
complete -c soar -n "__fish_soar_using_subcommand add" -l portable-config -d 'Set portable config' -r -F
complete -c soar -n "__fish_soar_using_subcommand add" -l portable-share -d 'Set portable share' -r -F
complete -c soar -n "__fish_soar_using_subcommand add" -l portable-cache -d 'Set portable cache' -r -F
complete -c soar -n "__fish_soar_using_subcommand add" -l name -d 'Override package name (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand add" -l version -d 'Override version (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand add" -l pkg-type -d 'Override package type (for URL installs, e.g., appimage, flatimage, archive)' -r
complete -c soar -n "__fish_soar_using_subcommand add" -l pkg-id -d 'Override package ID (for URL installs)' -r
complete -c soar -n "__fish_soar_using_subcommand add" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand add" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand add" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand add" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand add" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand add" -s f -l force -d 'Whether to force install the package'
complete -c soar -n "__fish_soar_using_subcommand add" -s y -l yes -d 'Skip all prompts and use first'
complete -c soar -n "__fish_soar_using_subcommand add" -l no-notes -d 'Don\'t display notes'
complete -c soar -n "__fish_soar_using_subcommand add" -l binary-only -d 'Exclude log, build/spec files, and desktop integration files'
complete -c soar -n "__fish_soar_using_subcommand add" -s a -l ask -d 'Ask for confirmation before installation'
complete -c soar -n "__fish_soar_using_subcommand add" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand add" -l show -d 'Show all available variants for interactive selection'
complete -c soar -n "__fish_soar_using_subcommand add" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand add" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand add" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand add" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand add" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand add" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand add" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand add" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c soar -n "__fish_soar_using_subcommand search" -l limit -d 'Limit number of result' -r
complete -c soar -n "__fish_soar_using_subcommand search" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand search" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand search" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand search" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand search" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand search" -l case-sensitive -d 'Case sensitive search'
complete -c soar -n "__fish_soar_using_subcommand search" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand search" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand search" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand search" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand search" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand search" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand search" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand search" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand search" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand s" -l limit -d 'Limit number of result' -r
complete -c soar -n "__fish_soar_using_subcommand s" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand s" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand s" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand s" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand s" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand s" -l case-sensitive -d 'Case sensitive search'
complete -c soar -n "__fish_soar_using_subcommand s" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand s" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand s" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand s" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand s" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand s" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand s" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand s" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand s" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand find" -l limit -d 'Limit number of result' -r
complete -c soar -n "__fish_soar_using_subcommand find" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand find" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand find" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand find" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand find" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand find" -l case-sensitive -d 'Case sensitive search'
complete -c soar -n "__fish_soar_using_subcommand find" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand find" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand find" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand find" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand find" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand find" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand find" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand find" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand find" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand query" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand query" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand query" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand query" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand query" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand query" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand query" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand query" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand query" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand query" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand query" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand query" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand query" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand query" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand Q" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand Q" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand Q" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand Q" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand Q" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand Q" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand Q" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand Q" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand Q" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand Q" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand Q" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand Q" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand Q" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand Q" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand remove" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand remove" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand remove" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand remove" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand remove" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand remove" -s y -l yes -d 'Skip prompts and use first match'
complete -c soar -n "__fish_soar_using_subcommand remove" -l all -d 'Remove all installed variants'
complete -c soar -n "__fish_soar_using_subcommand remove" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand remove" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand remove" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand remove" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand remove" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand remove" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand remove" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand remove" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand remove" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand r" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand r" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand r" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand r" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand r" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand r" -s y -l yes -d 'Skip prompts and use first match'
complete -c soar -n "__fish_soar_using_subcommand r" -l all -d 'Remove all installed variants'
complete -c soar -n "__fish_soar_using_subcommand r" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand r" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand r" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand r" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand r" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand r" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand r" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand r" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand r" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand del" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand del" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand del" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand del" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand del" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand del" -s y -l yes -d 'Skip prompts and use first match'
complete -c soar -n "__fish_soar_using_subcommand del" -l all -d 'Remove all installed variants'
complete -c soar -n "__fish_soar_using_subcommand del" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand del" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand del" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand del" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand del" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand del" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand del" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand del" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand del" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand sync" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand sync" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand sync" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand sync" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand sync" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand sync" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand sync" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand sync" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand sync" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand sync" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand sync" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand sync" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand sync" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand sync" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand S" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand S" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand S" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand S" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand S" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand S" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand S" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand S" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand S" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand S" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand S" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand S" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand S" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand S" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand fetch" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand fetch" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand fetch" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand fetch" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand fetch" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand fetch" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand fetch" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand fetch" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand update" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand update" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand update" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand update" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand update" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand update" -s k -l keep -d 'Keep old version'
complete -c soar -n "__fish_soar_using_subcommand update" -s a -l ask -d 'Ask for confirmation before update'
complete -c soar -n "__fish_soar_using_subcommand update" -l check -d 'Report what would be updated, without updating anything'
complete -c soar -n "__fish_soar_using_subcommand update" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand update" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand update" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand update" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand update" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand update" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand update" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand update" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand update" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand update" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand u" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand u" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand u" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand u" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand u" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand u" -s k -l keep -d 'Keep old version'
complete -c soar -n "__fish_soar_using_subcommand u" -s a -l ask -d 'Ask for confirmation before update'
complete -c soar -n "__fish_soar_using_subcommand u" -l check -d 'Report what would be updated, without updating anything'
complete -c soar -n "__fish_soar_using_subcommand u" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand u" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand u" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand u" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand u" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand u" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand u" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand u" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand u" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand u" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s k -l keep -d 'Keep old version'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s a -l ask -d 'Ask for confirmation before update'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -l check -d 'Report what would be updated, without updating anything'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand upgrade" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand info" -s r -l repo-name -d 'Repository to get installed packages for' -r
complete -c soar -n "__fish_soar_using_subcommand info" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand info" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand info" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand info" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand info" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand info" -l count -d 'Only show the unique package install count'
complete -c soar -n "__fish_soar_using_subcommand info" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand info" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand info" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand info" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand info" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand info" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand info" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand info" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand info" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s r -l repo-name -d 'Repository to get installed packages for' -r
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand list-installed" -l count -d 'Only show the unique package install count'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand list-installed" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand list" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand list" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand list" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand list" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand list" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand list" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand list" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand list" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand list" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand list" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand list" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand list" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand list" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand list" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand ls" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand ls" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand ls" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand ls" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand ls" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand ls" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand ls" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand ls" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand ls" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand ls" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand ls" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand ls" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand ls" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand ls" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand log" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand log" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand log" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand log" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand log" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand log" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand log" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand log" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand log" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand log" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand log" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand log" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand log" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand log" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand inspect" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand inspect" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand inspect" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand inspect" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand inspect" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand inspect" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand inspect" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand inspect" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand run" -l pkg-id -d 'Package id' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s r -l repo-name -d 'Repo name' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand run" -s y -l yes -d 'Skip all prompts and use first'
complete -c soar -n "__fish_soar_using_subcommand run" -l no-verify -d 'Skip checksum verification before running'
complete -c soar -n "__fish_soar_using_subcommand run" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand run" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand run" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand run" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand run" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand run" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand run" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand run" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand run" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand exec" -l pkg-id -d 'Package id' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s r -l repo-name -d 'Repo name' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand exec" -s y -l yes -d 'Skip all prompts and use first'
complete -c soar -n "__fish_soar_using_subcommand exec" -l no-verify -d 'Skip checksum verification before running'
complete -c soar -n "__fish_soar_using_subcommand exec" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand exec" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand exec" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand exec" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand exec" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand exec" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand exec" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand exec" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand exec" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand execute" -l pkg-id -d 'Package id' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s r -l repo-name -d 'Repo name' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand execute" -s y -l yes -d 'Skip all prompts and use first'
complete -c soar -n "__fish_soar_using_subcommand execute" -l no-verify -d 'Skip checksum verification before running'
complete -c soar -n "__fish_soar_using_subcommand execute" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand execute" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand execute" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand execute" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand execute" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand execute" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand execute" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand execute" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand execute" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand use" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand use" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand use" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand use" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand use" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand use" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand use" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand use" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand use" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand use" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand use" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand use" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand use" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand use" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand download" -s o -l output -d 'Output file path' -r -F
complete -c soar -n "__fish_soar_using_subcommand download" -s r -l regex -d 'Regex to select the asset. Only works for github downloads' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s g -l glob -d 'Glob to select the asset' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s m -l match -d 'Check if the asset contains given string' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s e -l exclude -d 'Exclude assets that contain the given string' -r
complete -c soar -n "__fish_soar_using_subcommand download" -l github -d 'Github project' -r
complete -c soar -n "__fish_soar_using_subcommand download" -l gitlab -d 'Gitlab project' -r
complete -c soar -n "__fish_soar_using_subcommand download" -l ghcr -d 'OCI reference' -r
complete -c soar -n "__fish_soar_using_subcommand download" -l extract-dir -d 'Directory where to extract the archive' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand download" -s y -l yes -d 'Automatically answer \'yes\' to all prompts Skips user interaction and uses default or first options'
complete -c soar -n "__fish_soar_using_subcommand download" -l exact-case -d 'Whether to use exact case matching for keywords'
complete -c soar -n "__fish_soar_using_subcommand download" -l extract -d 'Extract supported archive automatically'
complete -c soar -n "__fish_soar_using_subcommand download" -l skip-existing -d 'Skip existing download with same file'
complete -c soar -n "__fish_soar_using_subcommand download" -l force-overwrite -d 'Overwrite existing download with same file'
complete -c soar -n "__fish_soar_using_subcommand download" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand download" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand download" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand download" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand download" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand download" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand download" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand download" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand download" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand dl" -s o -l output -d 'Output file path' -r -F
complete -c soar -n "__fish_soar_using_subcommand dl" -s r -l regex -d 'Regex to select the asset. Only works for github downloads' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s g -l glob -d 'Glob to select the asset' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s m -l match -d 'Check if the asset contains given string' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s e -l exclude -d 'Exclude assets that contain the given string' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -l github -d 'Github project' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -l gitlab -d 'Gitlab project' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -l ghcr -d 'OCI reference' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -l extract-dir -d 'Directory where to extract the archive' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand dl" -s y -l yes -d 'Automatically answer \'yes\' to all prompts Skips user interaction and uses default or first options'
complete -c soar -n "__fish_soar_using_subcommand dl" -l exact-case -d 'Whether to use exact case matching for keywords'
complete -c soar -n "__fish_soar_using_subcommand dl" -l extract -d 'Extract supported archive automatically'
complete -c soar -n "__fish_soar_using_subcommand dl" -l skip-existing -d 'Skip existing download with same file'
complete -c soar -n "__fish_soar_using_subcommand dl" -l force-overwrite -d 'Overwrite existing download with same file'
complete -c soar -n "__fish_soar_using_subcommand dl" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand dl" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand dl" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand dl" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand dl" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand dl" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand dl" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand dl" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand dl" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand health" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand health" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand health" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand health" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand health" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand health" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand health" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand health" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand health" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand health" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand health" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand health" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand health" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand health" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s r -l repositories -d 'Enable only selected repositories' -r
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand defconfig" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "add" -d 'Add a new repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "update" -d 'Update an existing repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "remove" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "del" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "list" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "ls" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand repo; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l pubkey -d 'Base64-encoded public key for signature verification' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l enabled -d 'Whether the repository is enabled' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l desktop-integration -d 'Enable desktop integration' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l signature-verification -d 'Enable signature verification' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l sync-interval -d 'Sync interval (e.g., "1h", "12h", "1d")' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l url -d 'Repository metadata URL' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l pubkey -d 'Base64-encoded public key for signature verification' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l enabled -d 'Whether the repository is enabled' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l desktop-integration -d 'Enable desktop integration' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l signature-verification -d 'Enable signature verification' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l sync-interval -d 'Sync interval (e.g., "1h", "12h", "1d")' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from del" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add a new repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from help" -f -a "update" -d 'Update an existing repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from help" -f -a "list" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand repo; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "add" -d 'Add a new repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "update" -d 'Update an existing repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "remove" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "del" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "list" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "ls" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand repository; and not __fish_seen_subcommand_from add update remove del list ls help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l pubkey -d 'Base64-encoded public key for signature verification' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l enabled -d 'Whether the repository is enabled' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l desktop-integration -d 'Enable desktop integration' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l signature-verification -d 'Enable signature verification' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l sync-interval -d 'Sync interval (e.g., "1h", "12h", "1d")' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l url -d 'Repository metadata URL' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l pubkey -d 'Base64-encoded public key for signature verification' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l enabled -d 'Whether the repository is enabled' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l desktop-integration -d 'Enable desktop integration' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l signature-verification -d 'Enable signature verification' -r -f -a "true\t''
false\t''"
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l sync-interval -d 'Sync interval (e.g., "1h", "12h", "1d")' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from del" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add a new repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from help" -f -a "update" -d 'Update an existing repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from help" -f -a "list" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand repository; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand env" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand env" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand env" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand env" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand env" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand env" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand env" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand env" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand env" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand env" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand env" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand env" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand env" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand env" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand plugin-manifest" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand url" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand url" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand url" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand url" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand url" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand url" -l register -d 'Register soar as the handler for soar:// links'
complete -c soar -n "__fish_soar_using_subcommand url" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand url" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand url" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand url" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand url" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand url" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand url" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand url" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand url" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand clean" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand clean" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand clean" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand clean" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand clean" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand clean" -l cache -d 'Clean cache'
complete -c soar -n "__fish_soar_using_subcommand clean" -l broken-symlinks -d 'Clean broken symlinks'
complete -c soar -n "__fish_soar_using_subcommand clean" -l broken -d 'Clean broken packages'
complete -c soar -n "__fish_soar_using_subcommand clean" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand clean" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand clean" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand clean" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand clean" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand clean" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand clean" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand clean" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand clean" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -f -a "update" -d 'Update soar'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -f -a "uninstall" -d 'Uninstall soar'
complete -c soar -n "__fish_soar_using_subcommand self; and not __fish_seen_subcommand_from update uninstall help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompt'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "update" -d 'Update soar'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "uninstall" -d 'Uninstall soar'
complete -c soar -n "__fish_soar_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand apply" -l packages -d 'Path to packages.toml (default: ~/.config/soar/packages.toml)' -r -F
complete -c soar -n "__fish_soar_using_subcommand apply" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand apply" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand apply" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand apply" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand apply" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand apply" -l prune -d 'Remove packages not declared in packages.toml'
complete -c soar -n "__fish_soar_using_subcommand apply" -l dry-run -d 'Show what would be done without making changes'
complete -c soar -n "__fish_soar_using_subcommand apply" -s y -l yes -d 'Skip confirmation prompts'
complete -c soar -n "__fish_soar_using_subcommand apply" -l no-verify -d 'Skip checksum verification'
complete -c soar -n "__fish_soar_using_subcommand apply" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand apply" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand apply" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand apply" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand apply" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand apply" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand apply" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand apply" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand apply" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand defpackages" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand completions" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand completions" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand completions" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand completions" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand completions" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand completions" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand completions" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand completions" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand completions" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand completions" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand completions" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand completions" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand completions" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand completions" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s r -l repo -d 'Repository name (default: "custom")' -r
complete -c soar -n "__fish_soar_using_subcommand json2db" -s p -l profile -d 'Set current profile' -r
complete -c soar -n "__fish_soar_using_subcommand json2db" -s c -l config -d 'Provide custom config file' -r
complete -c soar -n "__fish_soar_using_subcommand json2db" -s P -l proxy -d 'Set proxy' -r
complete -c soar -n "__fish_soar_using_subcommand json2db" -s H -l header -d 'Set request headers' -r
complete -c soar -n "__fish_soar_using_subcommand json2db" -s A -l user-agent -d 'Set user agent' -r
complete -c soar -n "__fish_soar_using_subcommand json2db" -s v -l verbose -d 'Set output verbosity'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s q -l quiet -d 'Suppress outputs'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s j -l json -d 'Output as json'
complete -c soar -n "__fish_soar_using_subcommand json2db" -l no-color -d 'Disable colors in output'
complete -c soar -n "__fish_soar_using_subcommand json2db" -l no-progress -d 'Disable progress bar'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s 4 -l ipv4 -d 'Connect over IPv4 only'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s 6 -l ipv6 -d 'Connect over IPv6 only'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s S -l system -d 'Manage system-wide packages (requires root)'
complete -c soar -n "__fish_soar_using_subcommand json2db" -s h -l help -d 'Print help'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "config" -d 'Print the configuration file to stdout'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "install" -d 'Install packages'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "search" -d 'Search package'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "query" -d 'Query package info'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "remove" -d 'Remove packages'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "sync" -d 'Sync with remote metadata'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "update" -d 'Update packages'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "info" -d 'Show info about installed packages'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "list" -d 'List all available packages'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "log" -d 'Inspect package build log'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "inspect" -d 'Inspect package build script'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "run" -d 'Run packages without installing to PATH'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "use" -d 'Use package from different family'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "download" -d 'Download arbitrary files'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "health" -d 'Health check'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "defconfig" -d 'Generate default config'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "repo" -d 'Manage repositories'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "env" -d 'View env'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "plugin-manifest" -d 'Print how a frontend should drive this soar'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "url" -d 'Act on a soar:// link, or register soar as its handler'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "clean" -d 'Garbage collection'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "self" -d 'Modify the soar installation'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "apply" -d 'Apply declarative package configuration'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "defpackages" -d 'Generate default packages configuration'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "completions" -d 'Generate shell completions'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "json2db" -d 'Convert JSON metadata to SQLite database'
complete -c soar -n "__fish_soar_using_subcommand help; and not __fish_seen_subcommand_from config install search query remove sync update info list log inspect run use download health defconfig repo env plugin-manifest url clean self apply defpackages completions json2db help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c soar -n "__fish_soar_using_subcommand help; and __fish_seen_subcommand_from repo" -f -a "add" -d 'Add a new repository'
complete -c soar -n "__fish_soar_using_subcommand help; and __fish_seen_subcommand_from repo" -f -a "update" -d 'Update an existing repository'
complete -c soar -n "__fish_soar_using_subcommand help; and __fish_seen_subcommand_from repo" -f -a "remove" -d 'Remove a repository'
complete -c soar -n "__fish_soar_using_subcommand help; and __fish_seen_subcommand_from repo" -f -a "list" -d 'List configured repositories'
complete -c soar -n "__fish_soar_using_subcommand help; and __fish_seen_subcommand_from self" -f -a "update" -d 'Update soar'
complete -c soar -n "__fish_soar_using_subcommand help; and __fish_seen_subcommand_from self" -f -a "uninstall" -d 'Uninstall soar'
