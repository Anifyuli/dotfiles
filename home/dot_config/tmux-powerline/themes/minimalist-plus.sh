# shellcheck shell=bash
# Minimalist+ Theme - Adaptive (KDE dark/light auto-detect)

# No separators - just space
TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=" "

if grep -qi "LookAndFeelPackage.*light\|ColorScheme.*Light" ~/.config/kdeglobals 2>/dev/null; then
  # --- LIGHT MODE ---
  BG_SESSION=210  # light red
  BG_DIR=215      # light orange
  BG_BRANCH=220   # light yellow
  BG_BATTERY=115  # light aqua
  BG_TIME=110     # light blue
  BG_DATE=182     # light purple
  BG_HOST=217     # light magenta
  BG_WIN=250      # light gray (window tabs)
  FG=235          # dark gray / near-black
else
  # --- DARK MODE ---
  BG_SESSION=124  # dark red
  BG_DIR=166      # dark orange
  BG_BRANCH=172   # yellow
  BG_BATTERY=72   # aqua
  BG_TIME=66      # blue
  BG_DATE=132     # purple
  BG_HOST=175     # magenta
  BG_WIN=237      # dark gray (window tabs)
  FG=255          # white
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR='default'
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR="$FG"

# Window status current (active window)
TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "#[bg=${BG_WIN},fg=${FG}]"
    " #I#F  #W "
    "#[bg=default,fg=${FG}]"
    " "
)

# Window status style
TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    "bg=${BG_WIN},fg=${FG}"
)

# Window format
TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[bg=${BG_WIN},fg=${FG}]"
    " #I#{?window_flags,#F, }  #W "
)

# Left side: session, pwd, branch - Rainbow order
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "session_info ${BG_SESSION} ${FG}"
    "pwd_fish ${BG_DIR} ${FG}"
    "vcs_branch ${BG_BRANCH} ${FG}"
)

# Right side: battery (aqua), time (blue), date (purple), hostname (magenta) - Rainbow order
TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "battery ${BG_BATTERY} ${FG}"
    "time ${BG_TIME} ${FG}"
    "date ${BG_DATE} ${FG}"
    "hostname ${BG_HOST} ${FG}"
)

# Custom formats
TMUX_POWERLINE_SEG_TIME_FORMAT="%H:%M"
TMUX_POWERLINE_SEG_DATE_FORMAT="%d/%m/%Y"
TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="#S:#I:#P"
TMUX_POWERLINE_SEG_PWD_MAX_LEN="30"
TMUX_POWERLINE_SEG_BATTERY_TYPE="percentage"
