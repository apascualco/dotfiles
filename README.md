# dotfiles

Configuración de macOS: **zsh** (oh-my-zsh + powerlevel10k), **Neovim**, **tmux**, **git** y **Ghostty**.

## Instalación

### Opción A — Mac limpia (sin Homebrew)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/apascualco/dotfiles/main/installer)
```

### Opción B — Ya tienes Homebrew

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
  | `~/.config/nvim` | `ides/nvim` |
  | Ghostty `config` | `apps/ghostty/config` |
  | Espanso `config/default.yml` | `apps/espanso/config/default.yml` |
  | Espanso `match/custom/` (dir) | `apps/espanso/match/` |

- **Rectangle** es la excepción: guarda su configuración en un plist gestionado
  por `cfprefsd`, así que **no se puede enlazar** (macOS lo cachea y reescribe).
  `install.sh` la importa con `defaults import` desde
  `apps/rectangle/com.knollsoft.Rectangle.plist`, y solo si la máquina no tiene
  ya configuración propia. Para guardar tus atajos actuales en el repo:

  ```bash
  defaults export com.knollsoft.Rectangle \
    ~/.dotfiles/apps/rectangle/com.knollsoft.Rectangle.plist
  ```

- **Tooling de Neovim** → además del LSP (mason), `Brewfile` incluye binarios
  de formatter/linter usados por `conform.nvim` (prettier, stylua, black,
  isort, buf). `install.sh` instala también `gofumpt` y `goimports`.

## Permisos manuales en macOS (Rectangle + Espanso)

`install.sh` los instala y configura, pero **no puede concederles permisos**: la
base de datos TCC está protegida por SIP. En una máquina nueva, tras el install:

1. **Ajustes del Sistema → Privacidad y seguridad → Accesibilidad** → activa
   `Rectangle` y `Espanso`.
2. `open -a Rectangle && espanso start`

Síntoma de que falta ese permiso: las apps arrancan pero no hacen nada —
Rectangle ignora los atajos y `espanso start` falla con
`launchctl exited with non-zero code 3`.

### Snippets de Espanso

51 snippets en `apps/espanso/match/`, un fichero por dominio. Se recargan al
guardar; para listarlos todos: `espanso match list`.

| Fichero | Contenido |
|---|---|
| `base.yml` | fechas (`:fecha` `:fechal` `:hora` `:ts` `:semana`), `:mail`, `:uuid`, `:rama`, símbolos (`:->` `:ok` `:ko` `:--`) |
| `http.yml` | headers de curl (`:ct` `:acc` `:auth` `:pref` `:hdrs`) y requests (`:curlp` `:curlg` `:curlt`) |
| `shell.yml` | docker (`:dstop` `:drm` `:dvol` `:dprune`), npm (`:nlint` `:ntc`), `:cx`, `:cwd`, `:port` |
| `go.yml` | `:iferr` `:iferrw` `:ctxt` `:tt` `:bench` |
| `md.yml` | bloques (`:cbg` `:cbb` `:cbj` `:merm`), `:tbl`, `:todo`, `:det`, `:fm` |

Los de `shell.yml` salieron de contar el `~/.zsh_history`, no de suposiciones.
Criterio para añadir uno nuevo: **te has pillado escribiéndolo por tercera vez**.

Para comandos que ejecutas *siempre igual*, un alias en el zshrc es mejor que un
snippet. Estos están aquí porque suelen querer un retoque antes de ejecutarse:
el snippet deja texto editable, el alias se ejecuta tal cual.

### Atajos de Espanso y el teclado Spanish - ISO

En `apps/espanso/config/default.yml` hay dos ajustes que **no son los valores
por defecto**, y conviene saber por qué antes de "arreglarlos":

- La barra de búsqueda está en `CMD+SHIFT+SPACE`. El default de Espanso es
  `ALT+SPACE`, que en teclado español es el **espacio duro** (nbsp).
- `toggle_key` está en `OFF`. El default es doble-`ALT`, que se dispara sin
  querer y deja a Espanso mudo — con la sensación de que se ha roto.

Regla general para este teclado: **`Option` a secas no es un modificador
seguro**, porque `Option+1/2/3` son `|`, `@` y `#`. Las configs que se copian
por internet asumen teclado US, donde esas combinaciones están libres.

## Secrets / configuración local

`install.sh` crea dos archivos **no versionados** que el `zshrc` sourcea si existen.
Pon ahí tokens, claves y rutas privadas:

- `~/.local_zshrc`
- `~/.local_zshrc_alternative`

## Actualizar el Brewfile

```bash
brew bundle dump --force --describe --file ~/.dotfiles/Brewfile
```
