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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To use coreutils `brew install coreutils`
export COREUTILS_GNUBIN_DIR="/usr/local/opt/coreutils/libexec/gnubin/";
export PATH="$COREUTILS_GNUBIN_DIR:$PATH"
export EDITOR=vim
export MANPATH="/usr/local/man:$MANPATH"


# Python / pyenv
# export PATH="$(pyenv root)/shims:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/homebrew/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_LIBRARY_PATH="/usr/local/lib:/opt/homebrew/lib:$DYLD_LIBRARY_PATH"

#Ruby
# => Brew install chruby
# source /usr/local/share/chruby/chruby.sh
# source /usr/local/share/chruby/auto.sh
# => Brew install rbenv
# eval "$(rbenv init -)"
# if which ruby >/dev/null && which gem >/dev/null; then
#   PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
# fi

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

#
# gitfast updated for local only bash completion
# git bash completion
alias gcor='git checkoutr';
# `~/.oh-my-zsh/plugins/gitfast/git-completion.bash`

# ```
# 		# __gitcomp_nl "$(__git_refs '' $track)"
#                 # https://gist.github.com/mmrko/b3ec6da9bea172cdb6bd83bdf95ee817
#                 if [ "$command" = "checkoutr" ]; then
#                   __gitcomp_nl "$(__git_refs '' $track)"
#                 else
#                   __gitcomp_nl "$(__git_heads '' $track)"
#                 fi
# 		;;
# ```

# =======================
# Directory Aliases
# =======================
alias obsidian='cd /Users/alexanderlockwood/Library/Mobile\ Documents/iCloud~md~obsidian/Documents'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
