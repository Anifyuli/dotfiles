function glow --wraps glow --description 'glow, but pick gruvbox-dark/light by current terminal background'
    set -l style
    set -l bg (command kitty @ get-colors 2>/dev/null | string match -r '^background\s+#(\S+)' -g)

    if test -n "$bg"
        set -l r (math "0x"(string sub -l 2 $bg))
        set -l g (math "0x"(string sub -s 3 -l 2 $bg))
        set -l b (math "0x"(string sub -s 5 -l 2 $bg))
        set -l lum (math "0.299*$r + 0.587*$g + 0.114*$b")

        if test (math "$lum > 140") = 1
            set style ~/.config/glow/themes/gruvbox-light.json
        else
            set style ~/.config/glow/themes/gruvbox-dark.json
        end
    end

    if test -n "$style"
        command glow --style $style $argv
    else
        command glow $argv
    end
end
