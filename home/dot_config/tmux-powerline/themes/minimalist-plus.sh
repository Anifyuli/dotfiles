# shellcheck shell=bash
# Minimalist+ Theme - Colorful segments

# No separators - just space
TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=" "

# Color palette
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR='237'
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR='255'

# Window status current (active window)
TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "#[$(tp_format inverse)]"
    "$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD"
    " #I#F "
    "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
    " #W "
    "#[$(tp_format regular)]"
    "$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD"
)

# Window status style
TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    "$(tp_format regular)"
)

# Window format
TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[$(tp_format regular)]"
    "  #I#{?window_flags,#F, } "
    "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
    " #W "
)

# Left side: session (red), pwd (orange), branch (yellow) - Gruvbox dark palette
# Format: segment_name bg_color fg_color
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "session_info 124 255"
    "pwd_fish 166 255"
    "vcs_branch 172 255"
)

# Right side: battery (green), time (aqua), date (blue), hostname (purple) - Gruvbox dark palette
TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "battery 106 255"
    "time 72 255"
    "date 66 255"
    "hostname 132 255"
)

# Custom formats
TMUX_POWERLINE_SEG_TIME_FORMAT="%H:%M"
TMUX_POWERLINE_SEG_DATE_FORMAT="%d/%m/%Y"
TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="#S:#I:#P"
TMUX_POWERLINE_SEG_PWD_MAX_LEN="30"
TMUX_POWERLINE_SEG_BATTERY_TYPE="percentage"
