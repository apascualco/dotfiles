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
	mkdir -p "${HOME}/.config"
	# lazy.nvim se bootstrapea solo en el primer arranque de nvim (init.lua).
}

function install_go_tooling() {
	# Herramientas Go usadas por la configuración de Neovim (conform + LSP).
	if command -v go >/dev/null 2>&1; then
		command -v gofumpt >/dev/null 2>&1 || go install mvdan.cc/gofumpt@latest
		command -v goimports >/dev/null 2>&1 || go install golang.org/x/tools/cmd/goimports@latest
	fi
}

function create_symlinks() {
	# Back up any pre-existing real file/dir (or stale symlink) before linking, so
	# re-running on a machine that already has dotfiles never destroys them silently.
	local backup_dir="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

	link() {
		local src="$1" dest="$2"
		# Already the intended symlink → nothing to do (keeps install idempotent).
		[[ "$(readlink "$dest" 2>/dev/null)" == "$src" ]] && return
		# Anything else already there → move it to the backup dir first.
		if [[ -e "$dest" || -L "$dest" ]]; then
			mkdir -p "$backup_dir"
			mv "$dest" "$backup_dir/"
			echo "  ↩︎  backed up $dest → $backup_dir/"
		fi
		ln -sfn "$src" "$dest"
	}

	mkdir -p "${HOME}/.config"
	mkdir -p "${HOME}/Library/Application Support/com.mitchellh.ghostty"

	link "${SCRIPT_DIR}/apps/zsh/zshrc"               "${HOME}/.zshrc"
	link "${SCRIPT_DIR}/apps/zsh/p10k.zsh"            "${HOME}/.p10k.zsh"
	# Enlazamos TODO ~/.config/nvim al repo para mantener lockfile + estructura
	# completa y evitar estados mixtos (parte symlink, parte archivos sueltos).
	link "${SCRIPT_DIR}/ides/nvim"                     "${HOME}/.config/nvim"
	link "${SCRIPT_DIR}/apps/git/gitignore_global"    "${HOME}/.gitignore_global"
	link "${SCRIPT_DIR}/apps/git/gitconfig"           "${HOME}/.gitconfig"
	link "${SCRIPT_DIR}/ides/intellij/ideavimrc"      "${HOME}/.ideavimrc"
	link "${SCRIPT_DIR}/apps/tmux/tmux.conf"          "${HOME}/.tmux.conf"
	link "${SCRIPT_DIR}/apps/ghostty/config"          "${HOME}/Library/Application Support/com.mitchellh.ghostty/config"
}

function verify_installation() {
	# No abortamos aquí: dejamos feedback accionable al final.
	if ! brew bundle check --file="${SCRIPT_DIR}/Brewfile" --verbose; then
		echo
		echo "⚠️  Hay dependencias pendientes o desactualizadas del Brewfile."
		echo "   Ejecuta: brew bundle install --file=\"${SCRIPT_DIR}/Brewfile\""
	fi
}

function last_executions() {
	# Los providers ruby/node/perl de nvim están DESACTIVADOS en init.lua,
	# así que no instalamos los paquetes neovim de npm/gem (no se usan).

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

echo "🧰 Installing Go tooling (gofumpt/goimports)"
echo "-------------------------------------------------"
install_go_tooling
echo

echo "🔗 Creating symlinks"
echo "-------------------------------------------------"
create_symlinks
echo

echo "🎁 Final steps (rust)"
echo "-------------------------------------------------"
last_executions
echo

echo "🔎 Verifying Brewfile dependencies"
echo "-------------------------------------------------"
verify_installation
echo

echo "✅ Done. Abre una nueva terminal para cargar la configuración."
