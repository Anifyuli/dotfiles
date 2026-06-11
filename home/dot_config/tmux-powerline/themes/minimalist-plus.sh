# shellcheck shell=bash
# Minimalist+ Theme - Colorful segments

# No separators - just space
TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=" "

# Color palette - transparent background, adaptive foreground
TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR='default'
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR='terminal'

# Window status current (active window)
TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "#[bg=237,fg=terminal]"
    " #I#F  #W "
    "#[bg=default,fg=terminal]"
    " "
)

# Window status style
TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    "bg=237,fg=terminal"
)

# Window format
TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[bg=237,fg=terminal]"
    " #I#{?window_flags,#F, }  #W "
)

# Left side: session (red), pwd (orange), branch (yellow), env (green) - Rainbow order
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "session_info 124 terminal"
    "pwd_fish 166 terminal"
    "vcs_branch 172 terminal"
    "project_env 106 terminal"
)

# Right side: battery (aqua), time (blue), date (purple), hostname (magenta) - Rainbow order
TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "battery 72 terminal"
    "time 66 terminal"
    "date 132 terminal"
    "hostname 175 terminal"
)

# Custom formats
TMUX_POWERLINE_SEG_TIME_FORMAT="%H:%M"
TMUX_POWERLINE_SEG_DATE_FORMAT="%d/%m/%Y"
TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="#S:#I:#P"
TMUX_POWERLINE_SEG_PWD_MAX_LEN="30"
TMUX_POWERLINE_SEG_BATTERY_TYPE="percentage"
