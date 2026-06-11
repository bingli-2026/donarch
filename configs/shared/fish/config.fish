if status is-interactive
    # Commands to run in interactive sessions can go here

    # Enable starship
    starship init fish | source
    vfox activate fish | source
    zoxide init fish | source
end

# Set cursor theme for niri compositor
set -gx XCURSOR_THEME "Bibata-Modern-Ice"
set -gx XCURSOR_SIZE "24"

# Add scripts directory to PATH
fish_add_path $HOME/.config/scripts

# Set Chrome executable for Flutter web development
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable

alias vi nvim
alias vim nvim

alias pctl powerprofilesctl

alias ccc claude
alias ccd "claude --dangerously-skip-permissions"
alias codem "HOME=$HOME/.codex_xinta codex"
alias codey "HOME=$HOME/.codex_xuanzhi codex"


# Configure sudo askpass helper
set -gx SUDO_ASKPASS $HOME/.askpass.sh
set -gx DOCKER_BUILDKIT 1


# pnpm
set -gx PNPM_HOME "/home/davisye/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
