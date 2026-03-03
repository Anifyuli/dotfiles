# Minimalist Tmux Powerline Theme
# Clean, simple, yet aesthetic

# Left side: session name + current window
TMUX_POWERLINE_STATUS_LEFT=(
    "session_name"
    "window"
)

# Right side: time only (keep it minimal)
TMUX_POWERLINE_STATUS_RIGHT=(
    "time"
)

# Segment colors - muted palette
TMUX_POWERLINE_STATUS_LEFT_COLOR_BG="colour236"
TMUX_POWERLINE_STATUS_LEFT_COLOR_FG="colour247"
TMUX_POWERLINE_STATUS_LEFT_COLOR_ACTIVE_BG="colour60"
TMUX_POWERLINE_STATUS_LEFT_COLOR_ACTIVE_FG="colour255"

TMUX_POWERLINE_STATUS_RIGHT_COLOR_BG="colour236"
TMUX_POWERLINE_STATUS_RIGHT_COLOR_FG="colour247"

# Separator style
TMUX_POWERLINE_STATUS_SEPARATOR=""
TMUX_POWERLINE_STATUS_SEPARATOR_INSERT=""

# Window format
TMUX_POWERLINE_WINDOW_STATUS_CURRENT="#[fg=colour255,bg=colour60] #I:#W "
TMUX_POWERLINE_WINDOW_STATUS_STYLE="#[fg=colour247,bg=colour236] #I:#W "
