# Dotfiles
Storing some configuration.

    git clone git@github.com:alockwood05/dotfiles.git path/dotfiles
    ln -s path/dotfiles/.vimrc .vimrc
    ln -s path/dotfiles/.zshrc .zshrc

    git clone git@gtithup.com:powerline/fonts.git .vim/fonts
    ./.vim/fonts/.install.sh

Inside vim: this might be outdated
    :PlugInstall

## Suggested Setup
### VSCode
- install VSCode `% brew install --cask visual-studio-code`
- Signin to allow auto syncing of vscode settings
- Allow macos key repeats (instead of alternative charater popup)
  - `defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false`
