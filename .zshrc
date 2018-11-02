# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="avit"

plugins=(git)
source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To use coreutils `brew install coreutils`
export COREUTILS_GNUBIN_DIR="/usr/local/opt/coreutils/libexec/gnubin/";
export PATH="$COREUTILS_GNUBIN_DIR:$PATH"
export EDITOR=vim
export MANPATH="/usr/local/man:$MANPATH"

#Ruby
source /usr/local/share/chruby/chruby.sh


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

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

#
# One Medical specific
#

# Automatically jump to your onelife directory from anywhere
alias onelife='cd ~/Code/onemedical/onelife'
alias onelife-ssh='docker exec -it onelife_onelife_1 /bin/bash';
alias onelife-seed='bundle exec rake onelife:seeder:seed_from_db_dump';
alias onelife-migrate='bin/rails db:migrate RAILS_ENV=development';
alias onelife-inventory-index='rake onelife:search_index:reindex["AppointmentInventories"]'
