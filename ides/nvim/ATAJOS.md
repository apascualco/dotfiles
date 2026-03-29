# Guia de Atajos de Neovim

**Tecla lider:** `,`

---

## Indice
- [Movimiento basico (Vim nativo)](#movimiento-basico-vim-nativo)
- [Explorador de Archivos (NvimTree)](#explorador-de-archivos-nvimtree)
- [Busqueda Fuzzy (Telescope)](#busqueda-fuzzy-telescope)
- [LSP (Servidor de Lenguaje)](#lsp-servidor-de-lenguaje)
- [Diagnosticos y Errores](#diagnosticos-y-errores)
- [Git](#git)
- [Debugging (DAP)](#debugging-dap)
- [Buffers y Pestanas (Bufferline)](#buffers-y-pestanas-bufferline)
- [Terminal (toggleterm + nativo)](#terminal-toggleterm--nativo)
- [Gestion de Ventanas](#gestion-de-ventanas)
- [Navegacion de Codigo](#navegacion-de-codigo)
- [Edicion de Codigo](#edicion-de-codigo)
- [Autocompletado y Snippets (nvim-cmp + LuaSnip)](#autocompletado-y-snippets-nvim-cmp--luasnip)
- [Treesitter](#treesitter)
- [Surround (nvim-surround)](#surround-nvim-surround)
- [Autopairs (nvim-autopairs)](#autopairs-nvim-autopairs)
- [Go](#go)
- [Claude Code (IA)](#claude-code-ia)
- [Otras Herramientas](#otras-herramientas)
- [Tips y Trucos](#tips-y-trucos)

---

## Movimiento basico (Vim nativo)

### Movimiento por caracteres y palabras
| Atajo | Descripcion |
|-------|-------------|
| `h j k l` | Izquierda, abajo, arriba, derecha |
| `w` | Siguiente palabra (inicio) |
| `b` | Anterior palabra (inicio) |
| `e` | Final de la palabra actual/siguiente |
| `W` / `B` / `E` | Igual pero por WORDS (separados por espacios) |
| `f{char}` | Saltar a {char} hacia adelante en la linea |
| `F{char}` | Saltar a {char} hacia atras en la linea |
| `t{char}` | Saltar hasta antes de {char} hacia adelante |
| `T{char}` | Saltar hasta despues de {char} hacia atras |
| `;` | Repetir ultimo f/F/t/T |
| `,` | Repetir ultimo f/F/t/T en direccion opuesta |

### Movimiento por lineas
| Atajo | Descripcion |
|-------|-------------|
| `0` | Inicio de la linea |
| `^` | Primer caracter no-blanco de la linea |
| `$` | Final de la linea |
| `{numero}j` / `{numero}k` | Saltar N lineas abajo/arriba (relativenumber activo) |

### Movimiento por pantalla
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+d` | Media pagina abajo |
| `Ctrl+u` | Media pagina arriba |
| `Ctrl+f` | Pagina completa abajo |
| `Ctrl+b` | Pagina completa arriba |
| `H` | Parte superior de la pantalla |
| `M` | Mitad de la pantalla |
| `L` | Parte inferior de la pantalla |
| `zz` | Centrar linea actual en pantalla |
| `zt` | Linea actual arriba de la pantalla |
| `zb` | Linea actual abajo de la pantalla |

### Movimiento por archivo
| Atajo | Descripcion |
|-------|-------------|
| `gg` | Inicio del archivo |
| `G` | Final del archivo |
| `{numero}G` | Ir a linea N |
| `{` / `}` | Parrafo anterior / siguiente |
| `%` | Ir al parentesis/corchete/llave complementario |

### Busqueda en archivo
| Atajo | Descripcion |
|-------|-------------|
| `/texto` | Buscar hacia adelante |
| `?texto` | Buscar hacia atras |
| `n` / `N` | Siguiente / anterior resultado |
| `*` | Buscar la palabra bajo el cursor hacia adelante |
| `#` | Buscar la palabra bajo el cursor hacia atras |

> Config: `ignorecase + smartcase` activos -- busca case-insensitive salvo que uses mayusculas.
> `scrolloff = 8` -- siempre hay 8 lineas de contexto visible arriba/abajo del cursor.

---

## Explorador de Archivos (NvimTree)

### Atajos Principales
| Atajo | Descripcion |
|-------|-------------|
| `,e` | Abrir/cerrar explorador |
| `,ef` | Enfocar explorador |
| `,ee` | Mostrar archivo actual en explorador |
| `,ec` | Colapsar todos los nodos |
| `,er` | Refrescar arbol |

### Dentro del Explorador (buffer-local)
| Atajo | Descripcion |
|-------|-------------|
| `Enter` / `o` | Abrir archivo |
| `i` | Abrir en split horizontal |
| `s` / `v` / `Ctrl+v` | Abrir en split vertical |
| `Ctrl+x` | Abrir en split horizontal |
| `t` / `Ctrl+t` | Abrir en nueva pestana |
| `Tab` | Previsualizar |
| **Crear/Eliminar** | |
| `a` | Crear archivo/carpeta |
| `d` | Eliminar |
| `D` | Mover a papelera |
| `r` | Renombrar |
| `Ctrl+r` | Renombrar (omitir nombre de archivo) |
| **Copiar/Pegar** | |
| `x` | Cortar |
| `c` | Copiar |
| `p` | Pegar |
| `y` | Copiar nombre |
| `Y` | Copiar ruta relativa |
| `gy` | Copiar ruta absoluta |
| **Navegacion** | |
| `<` / `>` | Hermano anterior/siguiente |
| `P` | Ir a padre |
| `Backspace` | Cerrar directorio |
| `K` / `J` | Primer/ultimo hermano |
| `-` | Cambiar root a directorio padre |
| `[c` / `]c` | Git anterior/siguiente |
| **Filtros y otros** | |
| `I` | Toggle filtro gitignore |
| `H` | Toggle archivos ocultos |
| `R` | Refrescar |
| `q` | Cerrar |
| `g?` | Mostrar ayuda |

---

## Busqueda Fuzzy (Telescope)

### Buscar Archivos
| Atajo | Descripcion |
|-------|-------------|
| `,ff` | Buscar archivos |
| `,fF` | Buscar archivos (incluir ocultos e ignorados) |
| `,fg` | Buscar texto en archivos (live grep) |
| `,fs` | Buscar palabra bajo cursor (grep_string) |
| `,f/` | Buscar en buffer actual (fuzzy) |
| `,fw` | Buscar palabra bajo cursor en buffer actual |
| `,fb` | Cambiar buffer |
| `,fo` | Archivos recientes |
| `,fr` | Reabrir ultima busqueda |

### Otras Busquedas
| Atajo | Descripcion |
|-------|-------------|
| `,fh` | Ayuda (help tags) |
| `,fk` | Ver todos los keymaps |
| `,fc` | Comandos disponibles |
| `,f:` | Historial de comandos |
| `,f?` | Historial de busqueda |
| `,frg` | Registros |
| `,fm` | Marcadores (marks) |
| `,fj` | Lista de saltos (jumplist) |
| `,fn` | Historial de notificaciones |

### Git (Telescope)
| Atajo | Descripcion |
|-------|-------------|
| `,gs` | Git status (archivos modificados) |
| `,gb` | Ramas de git |
| `,gc` | Commits del repositorio |
| `,gC` | Commits del archivo actual |

### LSP (Telescope)
| Atajo | Descripcion |
|-------|-------------|
| `,lr` | Referencias del simbolo |
| `,li` | Implementaciones |
| `,ls` | Simbolos del documento |
| `,lS` | Simbolos del workspace |
| `,dd` | Todos los diagnosticos |

### Todo-comments (Telescope)
| Atajo | Descripcion |
|-------|-------------|
| `,ft` | Comentarios TODO (todos) |
| `,fT` | Solo TODO/FIX/FIXME |

### Extensiones de Telescope
| Atajo | Descripcion |
|-------|-------------|
| `,ss` | Explorar e insertar snippets (luasnip) |
| `,km` | Explorar keymaps personalizados (mapper) |

---

## LSP (Servidor de Lenguaje)

### Atajos rapidos (sin leader)
| Atajo | Descripcion |
|-------|-------------|
| `K` | Ver documentacion (hover) |
| `gd` | Ir a definicion (via Telescope) |
| `gD` | Ir a declaracion |
| `gr` | Ver referencias (via Telescope) |
| `gi` | Ir a implementacion (via Telescope) |
| `gt` | Ir a definicion de tipo (via Telescope) |
| `gl` | Diagnosticos de linea (float) |
| `Ctrl+Click` | Ir a definicion (raton) |

### Acciones Principales (con leader)
| Atajo | Descripcion |
|-------|-------------|
| `,la` | Acciones de codigo |
| `,la` (visual) | Acciones de codigo (rango visual) |
| `,lR` | Renombrar simbolo |
| `,ld` | Ir a definicion |
| `,lD` | Ir a declaracion |
| `,lt` | Ir a definicion de tipo |
| `,lh` | Hover / Toggle inlay hints |
| `,lK` | Ayuda de firma de funcion |
| `,lf` | Formatear buffer |
| `,lf` (visual) | Formatear seleccion |
| `,le` | Ver diagnostico bajo cursor |
| `,lq` | Llenar location list con diagnosticos |

### Info LSP
| Atajo | Descripcion |
|-------|-------------|
| `,lI` | Mostrar clientes LSP activos |
| `,lm` | Abrir Mason (gestor de paquetes LSP) |

---

## Diagnosticos y Errores

### Navegacion
| Atajo | Descripcion |
|-------|-------------|
| `[d` | Diagnostico anterior |
| `]d` | Diagnostico siguiente |
| `gl` | Diagnosticos de linea (float) |
| `,dd` | Todos los diagnosticos (Telescope) |
| `,td` | Toggle auto-popup de diagnosticos en CursorHold |

### Trouble (Panel de Errores)
| Atajo | Descripcion |
|-------|-------------|
| `,xx` | Toggle diagnosticos (workspace) |
| `,xd` | Toggle diagnosticos (buffer actual) |
| `,xd0` | Abrir diagnosticos del documento |
| `,xl` | Toggle location list |
| `,xq` | Toggle quickfix list |
| `,xs` | Toggle simbolos del documento |
| `,xlp` | Toggle panel LSP |
| `,xr` | Referencias LSP |

### Quickfix y Location List
| Atajo | Descripcion |
|-------|-------------|
| `]q` | Siguiente item en quickfix |
| `[q` | Item anterior en quickfix |
| `]l` | Siguiente item en location list |
| `[l` | Item anterior en location list |
| `,co` | Abrir quickfix |
| `,cc` | Cerrar quickfix |
| `,Lo` | Abrir location list |
| `,Lc` | Cerrar location list |

---

## Git

### Gitsigns (Hunks/Cambios)
| Atajo | Descripcion |
|-------|-------------|
| `,hs` | Stage hunk |
| `,hs` (visual) | Stage hunk (seleccion visual) |
| `,hr` | Reset hunk |
| `,hr` (visual) | Reset hunk (seleccion visual) |
| `,hu` | Deshacer stage hunk |
| `,hS` | Stage todo el buffer |
| `,hR` | Reset todo el buffer |
| `,hp` | Previsualizar hunk |
| `,hb` | Toggle blame de linea |
| `]h` | Siguiente hunk |
| `[h` | Hunk anterior |

### Diffview (Vista de Diferencias)
| Atajo | Descripcion |
|-------|-------------|
| `,gd` | Abrir diff (vs HEAD) |
| `,gD` | Cerrar diff |
| `,gh` | Historial del archivo actual |
| `,gH` | Historial del repositorio |
| `,gf` | Toggle panel de archivos |
| `,gF` | Enfocar panel de archivos |

### Git Conflict (resolucion de conflictos)

Plugin `git-conflict.nvim` con mappings por defecto:

| Atajo | Descripcion |
|-------|-------------|
| `co` | Elegir "ours" (cambio local) |
| `ct` | Elegir "theirs" (cambio remoto) |
| `cb` | Elegir ambos |
| `c0` | No elegir ninguno |
| `]x` | Siguiente conflicto |
| `[x` | Conflicto anterior |

---

## Debugging (DAP)

### Breakpoints
| Atajo | Descripcion |
|-------|-------------|
| `,db` | Toggle breakpoint |
| `,dB` | Breakpoint condicional |
| `,dL` | Logpoint (mensaje de log) |

### Controles de Debug
| Atajo | Descripcion |
|-------|-------------|
| `,dc` | Iniciar/continuar |
| `,dn` | Step over |
| `,di` | Step into |
| `,do` | Step out |
| `,dr` | Toggle REPL |
| `,dl` | Ejecutar ultimo |
| `,dt` | Terminar |

### UI de Debug
| Atajo | Descripcion |
|-------|-------------|
| `,du` | Toggle UI de debugger |
| `,de` | Evaluar expresion |
| `,dv` | Hover eval (normal/visual) |

### Debug Go
| Atajo | Descripcion |
|-------|-------------|
| `,dgt` | Debug test actual (Go) |
| `,dgl` | Debug ultimo test (Go) |

---

## Buffers y Pestanas (Bufferline)

| Atajo | Descripcion |
|-------|-------------|
| `Tab` | Buffer siguiente |
| `Shift+Tab` | Buffer anterior |
| `Ctrl+Alt+Right` | Buffer siguiente (alternativo) |
| `Ctrl+Alt+Left` | Buffer anterior (alternativo) |
| `,bp` | Elegir buffer por letra |
| `,bc` | Cerrar buffer actual |
| `,bo` | Cerrar otros buffers |
| `,br` | Cerrar buffers a la derecha |
| `,bl` | Cerrar buffers a la izquierda |
| `,b>` | Mover buffer a la derecha |
| `,b<` | Mover buffer a la izquierda |
| `,bsd` | Ordenar por directorio |
| `,bse` | Ordenar por extension |
| `,n` | Nuevo buffer vacio |

---

## Terminal (toggleterm + nativo)

### Atajos Principales
| Atajo | Descripcion |
|-------|-------------|
| `,T` | Toggle terminal inferior (nativo, 12 lineas) |
| `Ctrl+\` | Toggle ultimo terminal (toggleterm) |
| `,t1` a `,t9` | Toggle terminal 1-9 |
| `,tq` | Cerrar todos los terminales |

### Navegacion entre Terminales
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+PageDown` | Siguiente terminal |
| `Ctrl+PageUp` | Terminal anterior |

### Dentro del Terminal
| Atajo | Descripcion |
|-------|-------------|
| `Esc` | Salir del modo terminal |
| `Ctrl+h` | Moverse a ventana izquierda |
| `Ctrl+j` | Moverse a ventana inferior |
| `Ctrl+k` | Moverse a ventana superior |
| `Ctrl+l` | Moverse a ventana derecha |

---

## Gestion de Ventanas

### Navegacion entre Ventanas
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+h` | Ventana izquierda |
| `Ctrl+j` | Ventana inferior |
| `Ctrl+k` | Ventana superior |
| `Ctrl+l` | Ventana derecha |
| `Ctrl+w + Flechas` | Navegacion alternativa |

### Redimensionar Ventanas
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+Up` | Aumentar altura (+2) |
| `Ctrl+Down` | Disminuir altura (-2) |
| `Ctrl+Left` | Disminuir anchura (-2) |
| `Ctrl+Right` | Aumentar anchura (+2) |

### Splits (Divisiones)
| Atajo | Descripcion |
|-------|-------------|
| `,sv` | Split vertical |
| `,sh` | Split horizontal |
| `,sx` | Cerrar split actual |
| `,so` | Cerrar todos los otros splits |
| `,se` | Igualar tamano de splits |
| `,sm` | Toggle maximizar ventana actual |

### Soft Wrap (Ajuste de Linea)
| Atajo | Descripcion |
|-------|-------------|
| `,tw` | Toggle soft-wrap (visual, con linebreak + breakindent) |
| `,w8` | Ajustar a 80 columnas |
| `,w0` | Ajustar a 100 columnas |
| `,w2` | Ajustar a 120 columnas |

---

## Navegacion de Codigo

### Referencias (vim-illuminate)
| Atajo | Descripcion |
|-------|-------------|
| `]]` | Siguiente referencia de la palabra bajo cursor |
| `[[` | Referencia anterior |

### Flash.nvim (Salto Rapido)
| Atajo | Descripcion |
|-------|-------------|
| `s` | Saltar a ubicacion (normal, visual, operator) |
| `S` | Seleccion treesitter (normal, visual, operator) |
| `r` | Operacion remota (solo en operator mode) |
| `R` | Busqueda treesitter (operator/visual) |
| `Ctrl+s` (en busqueda `/` `?`) | Toggle Flash en busqueda |

### Harpoon v2 (Marcadores de Archivos)
| Atajo | Descripcion |
|-------|-------------|
| `,ma` | Anadir archivo actual a la lista |
| `,mm` | Toggle menu rapido |
| `,mn` | Siguiente item |
| `,mp` | Item anterior |
| `,m1` a `,m5` | Seleccionar item 1-5 |

### Comentarios TODO (todo-comments.nvim)
| Atajo | Descripcion |
|-------|-------------|
| `]t` | Siguiente TODO |
| `[t` | TODO anterior |

---

## Edicion de Codigo

### Comentarios (Comment.nvim)
| Atajo | Descripcion |
|-------|-------------|
| `,/` | Toggle comentario (linea actual o seleccion visual) |
| `gcc` | Toggle comentario linea actual |
| `gbc` | Toggle comentario bloque actual |
| `gc` (visual) | Toggle comentario seleccion (linea) |
| `gb` (visual) | Toggle comentario seleccion (bloque) |
| `gc{motion}` | Comentar con movimiento (ej: `gcap` comenta parrafo) |
| `gb{motion}` | Comentar bloque con movimiento |
| `gco` | Insertar comentario abajo |
| `gcO` | Insertar comentario arriba |
| `gcA` | Comentar al final de linea |

### Formato y Lint
| Atajo | Descripcion |
|-------|-------------|
| `,cf` | Formatear archivo (conform.nvim, async) |
| `,lf` | Formatear con LSP |
| `,lf` (visual) | Formatear seleccion con LSP |
| `,ll` | Ejecutar linter manualmente (nvim-lint) |

> Nota: conform.nvim formatea automaticamente al guardar (excepto SQL y Java).
> Los archivos Go se organizan imports + formatean automaticamente al guardar.
> Los archivos TS/JS ejecutan fixAll + organizeImports al guardar.

### Movimiento e Indentacion
| Atajo | Descripcion |
|-------|-------------|
| `<` (visual) | Reducir indentacion (mantiene seleccion) |
| `>` (visual) | Aumentar indentacion (mantiene seleccion) |
| `Alt+j` | Mover linea abajo |
| `Alt+k` | Mover linea arriba |
| `Alt+j` (visual) | Mover seleccion abajo |
| `Alt+k` (visual) | Mover seleccion arriba |
| `p` (visual) | Pegar sin copiar texto reemplazado |

### Guardar
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+s` | Guardar archivo (modo normal) |
| `Ctrl+s` | Guardar archivo (modo insercion, vuelve a insercion) |

---

## Autocompletado y Snippets (nvim-cmp + LuaSnip)

### Navegacion del menu
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+Space` | Activar/trigger autocompletado |
| `Tab` | Siguiente item (o trigger si no visible) |
| `Shift+Tab` | Item anterior |
| `Ctrl+n` | Siguiente item |
| `Ctrl+p` | Item anterior |
| `Up` / `Down` | Navegar items |

### Confirmar / Cancelar
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+y` | Confirmar autocompletado (selecciona si no hay eleccion) |
| `Enter` | Confirmar autocompletado (no auto-selecciona) |
| `Ctrl+e` | Cancelar/abortar autocompletado |

### Documentacion
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+u` | Scroll documentacion arriba (4 lineas) |
| `Ctrl+d` | Scroll documentacion abajo (4 lineas) |
| `Ctrl+h` | Toggle popup de documentacion |

### Snippets (LuaSnip)
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+j` | Saltar al siguiente nodo del snippet |
| `Ctrl+k` | Saltar al nodo anterior del snippet |
| `Ctrl+f` | Saltar siguiente placeholder (cmp, con fallback) |
| `Ctrl+b` | Saltar anterior placeholder (cmp, con fallback) |

---

## Treesitter

### Seleccion Incremental
| Atajo | Descripcion |
|-------|-------------|
| `Ctrl+Space` | Iniciar seleccion / expandir al siguiente nodo |
| `Backspace` | Reducir seleccion al nodo anterior |

### Inspeccion
| Atajo | Descripcion |
|-------|-------------|
| `,ti` | Inspeccionar highlight bajo cursor |
| `,tI` | Inspeccionar arbol de sintaxis (buffer) |

### Indent Blankline
| Atajo | Descripcion |
|-------|-------------|
| `,tig` | Toggle guias de indentacion |

---

## Surround (nvim-surround)

Mappings por defecto del plugin:

### Normal mode
| Atajo | Descripcion |
|-------|-------------|
| `ys{motion}{char}` | Rodear con {char} (ej: `ysiw"` rodea palabra con comillas) |
| `yss{char}` | Rodear toda la linea |
| `ds{char}` | Eliminar delimitador (ej: `ds"` elimina comillas) |
| `cs{old}{new}` | Cambiar delimitador (ej: `cs"'` cambia " por ') |

### Visual mode
| Atajo | Descripcion |
|-------|-------------|
| `S{char}` | Rodear seleccion con {char} |

> Caracteres especiales: `(` anade espacios internos, `)` no. Igual con `[`/`]` y `{`/`}`.
> Tambien soporta tags HTML: `ysiwt` + `div` = `<div>palabra</div>`.

---

## Autopairs (nvim-autopairs)

Funciona automaticamente en modo insercion (auto-cierra parentesis, llaves, corchetes, comillas).

| Atajo | Descripcion |
|-------|-------------|
| `Alt+e` | Fast wrap: envolver el siguiente texto con un delimitador |

> Fast wrap: al pulsar `Alt+e` en modo insercion, aparecen marcas en los caracteres de cierre cercanos.
> Pulsa la letra correspondiente para envolver hasta ese punto.

---

## Go

### Generacion de Codigo
| Atajo | Descripcion |
|-------|-------------|
| `,goj` | Anadir tags json |
| `,goy` | Anadir tags yaml |
| `,goA` | Anadir tags json + yaml |
| `,goR` | Remover todos los tags |
| `,goe` | Anadir if err |
| `,goi` | Implementar interfaz |
| `,gof` | Llenar struct |
| `,gos` | Llenar switch |
| `,goo` | Organizar imports |
| `,goq` | Quick fix (anadir import faltante) |

### Testing
| Atajo | Descripcion |
|-------|-------------|
| `,got` | Test funcion bajo cursor |
| `,goT` | Test archivo |
| `,goa` | Test paquete |
| `,gol` | Test ultimo |
| `,goc` | Cobertura |

### Ejecutar y Debugear
| Atajo | Descripcion |
|-------|-------------|
| `,gor` | Ejecutar (busca main.go automaticamente, selector si hay varios) |
| `,god` | Debugear (busca main.go automaticamente, carga .env.local) |
| `,gob` | Compilar directorio actual |

### Go Modules
| Atajo | Descripcion |
|-------|-------------|
| `,gmt` | go mod tidy |
| `,gmv` | go mod vendor |
| `,gmd` | go mod download |
| `,gmi` | go mod init (pide nombre del modulo) |

### Go Get/Generate
| Atajo | Descripcion |
|-------|-------------|
| `,ggi` | go get (pide paquete) |
| `,gg` | go generate ./... |

---

## Claude Code (IA)

| Atajo | Descripcion |
|-------|-------------|
| `,ac` | Toggle panel de Claude |
| `,af` | Enfocar/toggle Claude |
| `,ar` | Reanudar sesion |
| `,aC` | Continuar |
| `,am` | Seleccionar modelo |
| `,ab` | Anadir buffer actual |
| `,as` (visual) | Enviar seleccion visual |
| `,as` (en explorador) | Anadir archivo bajo cursor (NvimTree, neo-tree, oil) |
| `,al` | Enviar linea actual |
| `,aa` | Aceptar diff |
| `,ad` | Rechazar diff |

---

## Otras Herramientas

### Tagbar (Simbolos/Outline)
| Atajo | Descripcion |
|-------|-------------|
| `,tt` | Toggle Tagbar |
| `,to` | Abrir Tagbar |

### Spectre (Buscar y Reemplazar en proyecto)
| Atajo | Descripcion |
|-------|-------------|
| `,S` | Buscar y reemplazar en proyecto |
| `,Sf` | Buscar y reemplazar en archivo actual |
| `,Sw` | Buscar palabra bajo cursor |
| `,S` (visual) | Buscar y reemplazar seleccion |

### Sesiones (persistence.nvim)
| Atajo | Descripcion |
|-------|-------------|
| `,qs` | Restaurar sesion del directorio actual |
| `,ql` | Restaurar ultima sesion |
| `,qd` | No guardar sesion actual |

### Toggle Options
| Atajo | Descripcion |
|-------|-------------|
| `,un` | Toggle numeros de linea |
| `,ur` | Toggle numeros relativos |
| `,us` | Toggle corrector ortografico |
| `,uw` | Toggle ajuste de linea |

### Utilidades
| Atajo | Descripcion |
|-------|-------------|
| `Esc` | Limpiar highlight de busqueda |
| `Ctrl+s` | Guardar archivo |
| `,km` | Explorar keymaps personalizados |
| `,q` | Cerrar ventana |
| `,Q` | Cerrar todo |
| `,qq` | Cerrar todo (forzado) |

### Which-key

Pulsa `,` y espera -- aparecera un popup con todos los grupos disponibles.

### Satellite (scrollbar)

No tiene atajos -- muestra un scrollbar visual con marcadores de cursor, busqueda, diagnosticos, git y marks.

### nvim-colorizer

No tiene atajos -- colorea automaticamente codigos de color en el buffer (#FF0000, rgb(), hsl(), etc.).

### Render-markdown

No tiene atajos -- renderiza markdown automaticamente en el buffer.

### Dressing.nvim

No tiene atajos -- mejora los menus `vim.ui.select` y `vim.ui.input` con UI mas bonita.

### Snacks.nvim

Notificaciones mejoradas y resaltado de palabras automatico.

---

## Workflows Practicos

### Workflow: Debugging generico (DAP)

```
1. Abre el archivo con el codigo que quieres debugear
2. ,db    → Pon breakpoints donde necesites (o ,dB para condicional)
3. ,dc    → Iniciar debug
4. ,du    → Abrir UI del debugger (variables, stack, watches)
5. ,dn    → Step over (siguiente linea)
   ,di    → Step into (entrar en funcion)
   ,do    → Step out (salir de funcion)
6. ,dv    → Hover sobre variables para ver valores
   ,de    → Evaluar una expresion
7. ,dl    → Re-ejecutar ultima sesion
8. ,dt    → Terminar cuando acabes
```

### Workflow: Debug Go (`,god`)

```
1. ,db en las lineas que quieras parar
2. ,god   → Busca todos los main.go del proyecto automaticamente
           Si hay uno solo, lo lanza directo
           Si hay varios, te muestra un selector
           Carga .env.local automaticamente si existe en la raiz
           Abre la UI del debugger automaticamente
3. Navega con ,dn / ,di / ,do
4. ,dt para terminar
```

### Workflow: Debug un test Go

```
1. Coloca el cursor dentro de la funcion de test
2. ,dgt   → Debugea ese test especifico
3. ,dgl   → Re-ejecuta el ultimo test debugeado
```

### Workflow: Ejecutar Go (sin debug)

```
,gor    → Ejecutar main.go
          Busca todos los main.go del proyecto
          Si hay varios, muestra selector
          Abre un terminal con toggleterm
          Carga .env.local automaticamente
,gob    → Compilar directorio actual (go build .)
```

### Workflow: Testing Go

```
,got    → Test funcion bajo el cursor
,goT    → Test archivo completo
,goa    → Test paquete entero
,gol    → Re-ejecutar ultimo test
,goc    → Ver cobertura
```

### Workflow: Formateo y Lint

**Automatico (al guardar con Ctrl+s o :w):**
- **Go**: organiza imports + formatea con gofumpt via LSP
- **TS/JS/JSX/TSX**: eslint fixAll + organiza imports + prettier
- **Rust**: rustfmt
- **Python**: black + isort
- **Lua**: stylua
- **JSON/YAML/HTML/CSS/MD**: prettier
- **SQL y Java**: excluidos del format-on-save

**Manual:**
```
,cf     → Formatear con conform.nvim (async, con fallback a LSP)
,lf     → Formatear con LSP directamente
,lf     → En modo visual, formatea solo la seleccion
,ll     → Ejecutar linter manualmente
```

### Workflow: Go extras rapidos

```
,goe    → Insertar if err != nil { return err }
,goj    → Anadir tags json al struct bajo cursor
,goy    → Anadir tags yaml
,goA    → Anadir json + yaml a la vez
,goR    → Remover todos los tags
,goi    → Implementar interfaz (te pide cual)
,gof    → Llenar struct con todos los campos
,gos    → Llenar switch con todos los cases
,goo    → Organizar imports manualmente
,goq    → Quick fix: anadir import faltante
```

### Workflow: Git

```
1. ,gs    → Ver archivos modificados (Telescope)
2. ]h/[h  → Navegar entre hunks en un archivo
3. ,hp    → Previsualizar hunk bajo cursor
4. ,hs    → Stage hunk (o seleccion visual)
5. ,hS    → Stage buffer entero
6. ,hu    → Deshacer stage hunk
7. ,gd    → Abrir diff completo (Diffview vs HEAD)
8. ,gh    → Ver historial del archivo actual
9. ,hb    → Toggle blame en la linea
10. ,gD   → Cerrar diff cuando acabes
```

**Conflictos (git-conflict.nvim):**
```
]x / [x → Navegar entre conflictos
co      → Elegir cambio local (ours)
ct      → Elegir cambio remoto (theirs)
cb      → Elegir ambos
c0      → No elegir ninguno
```

### Workflow: Navegacion rapida por codigo

```
gd      → Ir a definicion (Telescope, con preview)
gr      → Ver todas las referencias
gi      → Ir a implementacion
gt      → Ir a tipo
K       → Hover documentacion
,la     → Code actions (fix, refactor, etc)
,lR     → Renombrar simbolo en todo el proyecto
]]      → Siguiente referencia de la palabra (illuminate)
[[      → Referencia anterior
s       → Flash jump (saltar a cualquier punto visible)
```

### Workflow: Buscar y reemplazar

```
,fg     → Live grep en todo el proyecto (Telescope)
,fs     → Grep palabra bajo cursor
,S      → Abrir Spectre (buscar y reemplazar en proyecto)
,Sw     → Buscar palabra bajo cursor en Spectre
,Sf     → Buscar y reemplazar solo en archivo actual
```

---

## Tips y Trucos

### Busqueda de Atajos
- Usa `,fk` o `:Telescope keymaps` para buscar cualquier atajo interactivamente
- Pulsa `,` y espera para ver which-key

### Uso del Raton
- Click en ventanas para cambiar el foco
- Arrastra los bordes para redimensionar ventanas
- Scroll con la rueda del raton
- Ctrl+Click para ir a definicion

### LSP - Atajos Rapidos
Los atajos LSP mas comunes estan disponibles sin leader:
- `K` - Documentacion rapida (hover)
- `gd` - Ir a definicion
- `gr` - Ver referencias
- `gi` - Ir a implementacion
- `gt` - Ir a tipo

---

## Lista de Plugins Instalados

| Plugin | Descripcion |
|--------|-------------|
| lazy.nvim | Gestor de plugins |
| nvim-tree.lua | Explorador de archivos |
| nvim-web-devicons | Iconos |
| catppuccin | Tema de colores |
| nvim-treesitter | Syntax highlighting y seleccion incremental |
| telescope.nvim | Busqueda fuzzy |
| telescope-fzf-native | Backend FZF para Telescope |
| telescope-luasnip | Explorador de snippets |
| nvim-mapper | Explorador de keymaps |
| tagbar | Outline de simbolos |
| nvim-lspconfig | Configuracion LSP |
| mason.nvim | Instalador de servidores LSP/DAP/linters |
| mason-lspconfig.nvim | Puente Mason + lspconfig |
| nvim-cmp | Autocompletado |
| cmp-nvim-lsp | Fuente LSP para cmp |
| cmp-nvim-lsp-signature-help | Firmas de funcion |
| cmp-buffer | Fuente buffer para cmp |
| cmp-path | Fuente paths para cmp |
| lspkind.nvim | Iconos VSCode en autocompletado |
| LuaSnip | Motor de snippets |
| cmp_luasnip | Fuente snippets para cmp |
| nvim-lint | Linter asincrono |
| conform.nvim | Formateador |
| trouble.nvim | Panel de diagnosticos |
| nvim-dap | Debug Adapter Protocol |
| nvim-dap-ui | UI para debugger |
| nvim-dap-virtual-text | Texto virtual en debug |
| mason-nvim-dap | Puente Mason + DAP |
| nvim-dap-go | Adapter Go para DAP |
| nvim-dap-repl-highlights | Highlighting en REPL de DAP |
| lualine.nvim | Barra de estado inferior |
| bufferline.nvim | Barra de buffers superior |
| gitsigns.nvim | Signos git en el gutter |
| diffview.nvim | Vista de diffs |
| git-conflict.nvim | Resolucion de conflictos |
| Comment.nvim | Comentar codigo |
| nvim-colorizer.lua | Colorea codigos de color |
| satellite.nvim | Scrollbar visual |
| nvim-spectre | Buscar y reemplazar en proyecto |
| harpoon | Marcadores rapidos de archivos |
| snacks.nvim | Notificaciones y utilidades |
| claudecode.nvim | Integracion con Claude Code |
| render-markdown.nvim | Renderizado de markdown |
| which-key.nvim | Popup de atajos disponibles |
| nvim-autopairs | Auto-cierre de delimitadores |
| indent-blankline.nvim | Guias de indentacion |
| nvim-surround | Manipular delimitadores |
| flash.nvim | Navegacion rapida |
| todo-comments.nvim | Resalta TODO/FIXME/etc |
| vim-illuminate | Resalta palabra bajo cursor |
| dressing.nvim | UI mejorada para select/input |
| persistence.nvim | Sesiones automaticas |
| go.nvim | Herramientas Go |
| guihua.lua | UI para go.nvim |
| toggleterm.nvim | Terminal con pestanas |

---

**Necesitas mas ayuda?**
- Ejecuta `:help` para la documentacion de Neovim
- Usa `,fh` para buscar en la ayuda con Telescope
- Usa `,fk` para buscar cualquier keybinding
- Config en `~/.config/nvim/lua/apascualco/keybinding.lua`
