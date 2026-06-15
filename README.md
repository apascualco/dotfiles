# dotfiles

Configuración de macOS: **zsh** (oh-my-zsh + powerlevel10k), **Neovim**, **tmux**, **git** y **Ghostty**.

## Instalación

```bash
git clone https://github.com/apascualco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` es **idempotente**: puedes re-ejecutarlo sin romper nada (solo instala/clona lo que falte).

## Qué hace

- **Homebrew** → instala todo lo declarado en [`Brewfile`](./Brewfile) vía `brew bundle`.
- **Runtimes** → sdkman (Java), gvm (Go), rustup (Rust).
- **zsh** → oh-my-zsh + powerlevel10k + plugins (`zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-completions`).
- **Symlinks** (apuntan al repo: editar aquí = editar la config viva):

  | Symlink | Destino |
  |---|---|
  | `~/.zshrc` | `apps/zsh/zshrc` |
  | `~/.p10k.zsh` | `apps/zsh/p10k.zsh` |
  | `~/.tmux.conf` | `apps/tmux/tmux.conf` |
  | `~/.gitconfig` | `apps/git/gitconfig` |
  | `~/.gitignore_global` | `apps/git/gitignore_global` |
  | `~/.ideavimrc` | `ides/intellij/ideavimrc` |
  | `~/.config/nvim/{init.lua,lua}` | `ides/nvim/...` |
  | Ghostty `config` | `apps/ghostty/config` |

## Secrets / configuración local

`install.sh` crea dos archivos **no versionados** que el `zshrc` sourcea si existen.
Pon ahí tokens, claves y rutas privadas:

- `~/.local_zshrc`
- `~/.local_zshrc_alternative`

## Actualizar el Brewfile

```bash
brew bundle dump --force --describe --file ~/.dotfiles/Brewfile
```
