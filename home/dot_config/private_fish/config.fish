if status is-interactive
    abbr --add warpstat 'curl https://www.cloudflare.com/cdn-cgi/trace/'
end

# Ensure $HOME/.local/bin is in PATH
if not contains -- $HOME/.local/bin $PATH
    set -gx PATH $HOME/.local/bin $HOME/bin $PATH
end

# Android SDK configuration
set -gx ANDROID_HOME $HOME/.android/sdk
set -gx ANDROID_AVD_HOME $HOME/.android/avd
set -gx ANDROID_SDK_ROOT $ANDROID_HOME

for dir in \
    $ANDROID_HOME/cmdline-tools/latest/bin \
    $ANDROID_HOME/emulator \
    $ANDROID_HOME/platform-tools
    if not contains -- $dir $PATH
        set -gx PATH $PATH $dir
    end
end

# Add NPM bin to $PATH
if not contains -- $HOME/.npm/bin $PATH
    set -gx PATH $HOME/.npm/bin $PATH
end

# $PNPM_HOME
set -gx PNPM_HOME $HOME/.local/share/pnpm
if not contains -- $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end

