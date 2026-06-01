# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added a config file for you to customize HyDE

#  Aliases 
# Override aliases here in 'config.fish' (already set )

# # Helpful aliases
# alias c='clear'                                                        # but don't use this one tho! just press `CLTR+l`
# alias l='eza -lh --icons=auto'                                         # long list
# alias ls='eza -1 --icons=auto'                                         # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias ld='eza -lhD --icons=auto'                                       # long list dirs
# alias lt='eza --icons=auto --tree'                                     # list folder as tree
# alias un='$aurhelper -Rns'                                             # uninstall package
# alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
# alias po='$aurhelper -Qtdq | $aurhelper -Rns -'                        # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
# alias vc='code'                                                        # gui code editor
# alias fastfetch='fastfetch --logo-type kitty'

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
# alias mkdir='mkdir -p'

#  This is your file 
# Add your configurations here

# DeepSeek / Anthropic-compatible API settings
set -gx ANTHROPIC_BASE_URL "https://api.deepseek.com/anthropic"
set -gx ANTHROPIC_MODEL "deepseek-v4-pro[1m]"
set -gx ANTHROPIC_DEFAULT_OPUS_MODEL "deepseek-v4-pro[1m]"
set -gx ANTHROPIC_DEFAULT_SONNET_MODEL "deepseek-v4-pro[1m]"
set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL "deepseek-v4-flash"
set -gx CLAUDE_CODE_SUBAGENT_MODEL "deepseek-v4-flash"
set -gx CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC 1
set -gx CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK 1

if not set -q DEEPSEEK_API_KEY
    set -l deepseek_api_key (secret-tool lookup service deepseek name DEEPSEEK_API_KEY 2>/dev/null)
    if test -n "$deepseek_api_key"
        set -gx DEEPSEEK_API_KEY "$deepseek_api_key"
    end
end

if set -q DEEPSEEK_API_KEY
    set -gx ANTHROPIC_AUTH_TOKEN $DEEPSEEK_API_KEY
end

# set EDITOR and VISUAL to nvim
set -gx EDITOR nvim
set -gx VISUAL nvim

# set aurhelper yay
set aurhelper paru
