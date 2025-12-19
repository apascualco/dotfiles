#!/bin/bash

brew update
brew upgrade

# CLI tools
brew install wget
brew install zsh
brew install zsh-syntax-highlighting
brew install fzf
brew install node
brew install universal-ctags
brew install kubectl
brew install textmate
brew install jq
brew install yq
brew install ripgrep
brew install tmux
brew install htop
brew install gh
brew install bat
brew install btop
brew install eza
brew install fd
brew install lazydocker
brew install tig
brew install yazi

# Development
brew install go
brew install neovim --HEAD
brew install golangci-lint
brew install gopls
brew install terraform-ls
brew install tree-sitter

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Casks (GUI apps)
brew install --cask iterm2
brew install --cask google-chrome
brew install --cask docker
brew install --cask spotify
brew install --cask ghostty
brew install stats
