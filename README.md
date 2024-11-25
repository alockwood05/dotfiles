# Dotfiles
Storing some configuration.

```
git clone git@github.com:alockwood05/dotfiles.git
cd ~/.vim
```

Replace `~/GitHub` with your path
```
ln -s ~/GitHub/dotfiles/.vimrc ~/.vimrc &
ln -s ~/GitHub/dotfiles/.zshrc ~/.zshrc &
ln -s ~/GitHub/dotfiles/.vim/ ~/.vim
ln -s ~/GitHub/dotfiles/.hammerspoon/ ~/.hammerspoon
ln -s ~/GitHub/dotfiles/.obsidian.vimrc ~/Library/Mobil\ Documents/iCloud~md~obsidian/Documents/unimaginable.life

```

install powerline fonts
```
    git clone git@gtithup.com:powerline/fonts.git
    ./fonts/.install.sh
```

Inside vim: this might be outdated
```
:PlugInstall
```

## Suggested Setup, overview
### VSCode
- install VSCode `% brew install --cask visual-studio-code`
- Signin to allow auto syncing of vscode settings
- Allow macos key repeats (instead of alternative charater popup)
  - `defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false`

###  Hammerspoon tool to customize system events in macos

```
brew install hammerspoon
```

try running `hs` should prompt

symlink hammerspoon folder
