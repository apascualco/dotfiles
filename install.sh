#!/bin/bash

function install_apps_with_brew() {
	brew update 
	brew upgrade
	brew install wget
	brew install --cask iterm2
	brew install zsh
	brew install go
	brew install neovim --HEAD
	brew install zsh-syntax-highlighting
	brew install fzf
	brew install --cask google-chrome
	brew install node
	brew install ctags
	brew install kubectl
	brew install --cask docker
	brew install --cask mysqlworkbench
	brew install --cask spotify
	brew install --cask lastpass
	brew install --cask intellij-idea
}

function install_python() {
    sudo python3 -m pip install --upgrade pip
    pip install virtualenv
}

function install_and_configura_zsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || true
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || true
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

function install_meslo_lg_font(){
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P tmp/
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P tmp/
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P tmp/
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P tmp/
	cp tmp/*.ttf /Library/Fonts/
	rm tmp/*
}


function install_nvim_and_configure(){
	mkdir -p ${HOME}/.config/nvim/venvs
    virtualenv -p ${HOME}/.config/nvim/venvs/neovim2 --python=python2
    virtualenv -p ${HOME}/.config/nvim/venvs/neovim3 --python=python3
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

function create_symlinks() {
	ln -sf ${PWD}/mac/Library/Preferences/com.googlecode.iterm2.plist ${HOME}/Library/Preferences/com.googlecode.iterm2.plist
	ln -sf ${PWD}/mac/Library/Preferences/com.googlecode.iterm2.plist ${HOME}/Library/Preferences/com.apple.dock.plist

	ln -sf ${PWD}/apps/zsh/zshrc ${HOME}/.zshrc
	ln -sf ${PWD}/apps/zsh/p10k.zsh ${HOME}/.p10k.zsh

	ln -sF ${PWD}/ides/nvim/init.vim ${HOME}/.config/nvim/init.vim
	ln -sF ${PWD}/apps/git/gitignore_global ${HOME}/.gitignore_global
	ln -sF ${PWD}/apps/git/gitconfig ${HOME}/.gitconfig
}

function last_executions() {
	nvim +PlugInstall +qall
    npm install -g neovim
    sudo gem install neovim

	osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'${PWD}'/mac/wallpaper.jpg"'

	#Mac configurations
	defaults write com.apple.dock autohide -bool true
	defaults delete com.apple.dock persistent-apps
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock tilesize -int 40
	defaults write com.apple.dock launchanim -bool false
	defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton
	killall Dock

	git config --global core.excludesfile ~/.gitignore_global

	# Preparing go enviroment
	mkdir -p ${HOME}/workdir/code/go
	go install github.com/go-delve/delve/cmd/dlv@latest

	# Update
	softwareupdate -i -a
}

echo "??? Installing apps with brew!"
echo "-------------------------------------------------"
install_apps_with_brew
install_python
echo

echo "??? Install meslo lg fonts"
echo "-------------------------------------------------"
install_meslo_lg_font
echo

echo "???? Install ZSH"
echo "-------------------------------------------------"
install_and_configura_zsh
echo

echo "???? Install neovim"
echo "-------------------------------------------------"
install_nvim_and_configure
echo

echo "Creating symlinks"
echo "-------------------------------------------------"
create_symlinks
echo

echo "Finishing the instalations, configurations and update xcode"
echo "-------------------------------------------------"
last_executions
echo
