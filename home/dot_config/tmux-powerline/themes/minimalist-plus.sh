# shellcheck shell=bash
# Minimalist+ Theme - Gruvbox (KDE dark/light auto-detect)

# No separators - just space
TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_LEFT_THIN=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=" "
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=" "

# Gruvbox palette (shared across both modes — warm earthy tones)
GR_RED="#cc241d"
GR_GREEN="#98971a"
GR_YELLOW="#d79921"
GR_BLUE="#458588"
GR_PURPLE="#b16286"
GR_AQUA="#689d6a"
GR_ORANGE="#d65d0e"
GR_FG0="#fbf1c7"
GR_BG0="#282828"

if grep -qi "LookAndFeelPackage.*light\|ColorScheme.*Light" ~/.config/kdeglobals 2>/dev/null; then
  # --- LIGHT MODE ---
  FG="#3c3836"        # dark text on light bg
  FG_DIM="#7c6f64"    # inactive window numbers (darker = lebih terang di bg terang)
  ACTIVE_BG="#d65d0e" # accent bg for active window
  ACTIVE_FG="#fbf1c7" # bright text on accent
else
  # --- DARK MODE ---
  FG="#ebdbb2"
  FG_DIM="#bdae93"
  ACTIVE_BG="#d65d0e"
  ACTIVE_FG="#fbf1c7"
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR='default'
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR="$FG"

# Window status current (active window) — accent bg, bold, padded
TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "#[bg=${ACTIVE_BG},fg=${ACTIVE_FG},bold]"
    " #I "
)

# Window status format (inactive windows) — transparent bg, dimmed number, padded
TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "#[bg=default,fg=${FG_DIM}]"
    " #I#{?window_zoomed_flag,Z,}#{?window_bell_flag,!,}#{?window_activity_flag,#,}#{?window_silence_flag,~,} "
)

# Left side: session, pwd, branch
TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "session_info ${GR_RED} ${GR_FG0}"
    "pwd_fish ${GR_ORANGE} ${GR_FG0}"
    "vcs_branch ${GR_YELLOW} ${GR_FG0}"
)

# Right side: battery, time, date, hostname
TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "battery ${GR_AQUA} ${GR_FG0}"
    "time ${GR_BLUE} ${GR_FG0}"
    "date ${GR_PURPLE} ${GR_FG0}"
    "hostname ${GR_ORANGE} ${GR_FG0}"
)

# Custom formats
TMUX_POWERLINE_SEG_TIME_FORMAT="%H:%M"
TMUX_POWERLINE_SEG_DATE_FORMAT="%d/%m/%Y"
TMUX_POWERLINE_SEG_TMUX_SESSION_INFO_FORMAT="#S:#I:#P"
TMUX_POWERLINE_SEG_PWD_MAX_LEN="30"
TMUX_POWERLINE_SEG_BATTERY_TYPE="percentage"
