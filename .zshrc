# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="avit"
plugins=(virtualenv git gitfast)
source $ZSH/oh-my-zsh.sh
export VIRTUAL_ENV_DISABLE_PROMPT=yes

# To use coreutils `brew install coreutils`
export COREUTILS_GNUBIN_DIR="/usr/local/opt/coreutils/libexec/gnubin/";
export HOMEBREW_PATH="/opt/homebrew/bin"
export PATH="$HOMEBREW_PATH:$COREUTILS_GNUBIN_DIR:$PATH"
export EDITOR=vim
export MANPATH="/usr/local/man:$MANPATH"



export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/homebrew/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_LIBRARY_PATH="/usr/local/lib:/opt/homebrew/lib:$DYLD_LIBRARY_PATH"

# NODE - USE FNM "Fast Nodeversion Manager"
# `brew install fnm
# `fnm install --lts`


# Python, other Languages `mise` for local version management

eval "$(mise activate)"
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
## Customizations

# Better `ls`
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls='ls -p'
# Better `grep`
export GREP_OPTIONS='--color=auto'

# brew install grc
# Colorized `traceroute`, `tail`, `head` (requires prepending command with `grc`)
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh


alias dc='docker-compose'
# history -E shows timestamps in zsh
alias hist='history -E | grep '
alias vimcc='rm ~/.vim-tmp/* ~/.vim-tmp/.*'
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

alias obsidian='cd /Users/alexanderlockwood/Library/Mobile\ Documents/iCloud~md~obsidian/Documents'


echo ".zshrc is loaded"
