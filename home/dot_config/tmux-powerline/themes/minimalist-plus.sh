# shellcheck shell=bash
# Minimalist+ Theme - Colorful segments

# No separators - just space
TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=" "

# Color palette - transparent background
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR='default'
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR='255'

# Window status current (active window)
TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "#[bg=237,fg=255]"
    " #I#F  #W "
    "#[bg=default,fg=255]"
    " "
)

# Window status style
TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    "bg=237,fg=255"
)

# Window format
TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[bg=237,fg=255]"
    " #I#{?window_flags,#F, }  #W "
)

# Left side: session (red), pwd (orange), branch (yellow), env (green) - Muted rainbow
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "session_info 88 255"
    "pwd_fish 130 255"
    "vcs_branch 142 255"
    "project_env 100 255"
)

# Right side: battery (aqua), time (blue), date (purple), hostname (magenta) - Muted rainbow
TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "battery 65 255"
    "time 60 255"
    "date 96 255"
    "hostname 95 255"
)

# Custom formats
TMUX_POWERLINE_SEG_TIME_FORMAT="%H:%M"
TMUX_POWERLINE_SEG_DATE_FORMAT="%d/%m/%Y"
TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="#S:#I:#P"
TMUX_POWERLINE_SEG_PWD_MAX_LEN="30"
TMUX_POWERLINE_SEG_BATTERY_TYPE="percentage"
