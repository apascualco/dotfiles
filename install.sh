#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function install_apps_with_brew() {
	source "${SCRIPT_DIR}/brew.sh"
}

function install_java() {
	# sdkman; el zshrc ya lo sourcea, así que NO tocamos ~/.zshrc aquí
	# (es un symlink al repo: un append lo habría corrompido).
	[[ -d "$HOME/.sdkman" ]] || curl -s "https://get.sdkman.io" | bash
}

function install_gvm_go() {
	[[ -s "$HOME/.gvm/scripts/gvm" ]] || \
		bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
}

function install_and_configure_zsh() {
	if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	fi

	local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
	# Todos los plugins externos que referencia el zshrc (antes faltaban
	# autosuggestions y completions, que provocaban warnings en cada arranque).
	[[ -d "$zsh_custom/themes/powerlevel10k" ]]            || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
	[[ -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
	[[ -d "$zsh_custom/plugins/zsh-autosuggestions" ]]     || git clone https://github.com/zsh-users/zsh-autosuggestions.git "$zsh_custom/plugins/zsh-autosuggestions"
	[[ -d "$zsh_custom/plugins/zsh-completions" ]]         || git clone https://github.com/zsh-users/zsh-completions.git "$zsh_custom/plugins/zsh-completions"

	# Config local / secrets (no versionada); el zshrc la sourcea si existe.
	touch ~/.local_zshrc ~/.local_zshrc_alternative
}

function install_nvim_and_configure() {
	mkdir -p "${HOME}/.config/nvim"
	# lazy.nvim se bootstrapea solo en el primer arranque de nvim (init.lua).
}

function create_symlinks() {
	ln -sf  "${SCRIPT_DIR}/apps/zsh/zshrc"               "${HOME}/.zshrc"
	ln -sf  "${SCRIPT_DIR}/apps/zsh/p10k.zsh"            "${HOME}/.p10k.zsh"

	ln -sf  "${SCRIPT_DIR}/ides/nvim/init.lua"           "${HOME}/.config/nvim/init.lua"
	ln -sfn "${SCRIPT_DIR}/ides/nvim/lua"                "${HOME}/.config/nvim/lua"
	ln -sf  "${SCRIPT_DIR}/apps/git/gitignore_global"    "${HOME}/.gitignore_global"
	ln -sf  "${SCRIPT_DIR}/apps/git/gitconfig"           "${HOME}/.gitconfig"
	ln -sf  "${SCRIPT_DIR}/ides/intellij/ideavimrc"      "${HOME}/.ideavimrc"
	ln -sf  "${SCRIPT_DIR}/apps/tmux/tmux.conf"          "${HOME}/.tmux.conf"

	# Ghostty
	mkdir -p "${HOME}/Library/Application Support/com.mitchellh.ghostty"
	ln -sf "${SCRIPT_DIR}/apps/ghostty/config" "${HOME}/Library/Application Support/com.mitchellh.ghostty/config"
}

function last_executions() {
	# Los providers ruby/node/perl de nvim están DESACTIVADOS en init.lua,
	# así que no instalamos los paquetes neovim de npm/gem (no se usan).

	# Configuración de macOS (tolerante si una clave ya no existe).
	defaults write com.apple.dock autohide -bool true
	defaults delete com.apple.dock persistent-apps 2>/dev/null || true
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock tilesize -int 40
	defaults write com.apple.dock launchanim -bool false
	defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton
	killall Dock || true

	# Rust (no interactivo). El gitignore global ya queda fijado vía gitconfig.
	[[ -d "$HOME/.cargo" ]] || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

echo "⚡ Installing apps with brew (Brewfile)!"
echo "-------------------------------------------------"
install_apps_with_brew
echo

echo "⚡ Installing language runtimes (sdkman/java, gvm/go)!"
echo "-------------------------------------------------"
install_java
install_gvm_go
echo

echo "💻 Configuring ZSH (oh-my-zsh + powerlevel10k + plugins)"
echo "-------------------------------------------------"
install_and_configure_zsh
echo

echo "💻 Preparing Neovim"
echo "-------------------------------------------------"
install_nvim_and_configure
echo

echo "🔗 Creating symlinks"
echo "-------------------------------------------------"
create_symlinks
echo

echo "🎁 Final steps (macOS defaults, rust)"
echo "-------------------------------------------------"
last_executions
echo

echo "✅ Done. Abre una nueva terminal para cargar la configuración."
