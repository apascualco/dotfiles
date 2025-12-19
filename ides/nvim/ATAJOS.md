# 🚀 Guía de Atajos de Neovim

**Tecla líder:** `,`

---

## 📑 Índice
- [📁 Explorador de Archivos](#-explorador-de-archivos-nvimtree)
- [🔍 Búsqueda Fuzzy](#-búsqueda-fuzzy-telescope)
- [💡 LSP (Servidor de Lenguaje)](#-lsp-servidor-de-lenguaje)
- [🐛 Diagnósticos y Errores](#-diagnósticos-y-errores)
- [🌿 Git](#-git)
- [🔧 Debugging](#-debugging-dap)
- [📋 Buffers y Pestañas](#-buffers-y-pestañas)
- [💻 Terminal](#-terminal)
- [🪟 Gestión de Ventanas](#-gestión-de-ventanas)
- [🧭 Navegación de Código](#-navegación-de-código)
- [✏️ Edición de Código](#️-edición-de-código)
- [🐹 Go](#-go)
- [🤖 Claude Code](#-claude-code-ia)
- [🛠️ Otras Herramientas](#️-otras-herramientas)

---

## 📁 Explorador de Archivos (NvimTree)

### Atajos Principales
| Atajo | Descripción |
|-------|-------------|
| `,e` | Abrir/cerrar explorador |
| `,ef` | Enfocar explorador |
| `,ee` | Mostrar archivo actual en explorador |
| `,ec` | Colapsar todos los nodos |
| `,er` | Refrescar árbol |

### Dentro del Explorador
| Atajo | Descripción |
|-------|-------------|
| `Enter` / `o` | Abrir archivo |
| `i` | Abrir en split horizontal |
| `s` / `v` | Abrir en split vertical |
| `t` | Abrir en nueva pestaña |
| `Tab` | Previsualizar |
| **Crear/Eliminar** |
| `a` | Crear archivo/carpeta |
| `d` | Eliminar |
| `D` | Mover a papelera |
| `r` | Renombrar |
| `Ctrl+r` | Renombrar (omitir nombre de archivo) |
| **Copiar/Pegar** |
| `x` | Cortar |
| `c` | Copiar |
| `p` | Pegar |
| `y` | Copiar nombre |
| `Y` | Copiar ruta relativa |
| `gy` | Copiar ruta absoluta |
| **Navegación** |
| `<` / `>` | Hermano anterior/siguiente |
| `P` | Ir a padre |
| `-` | Cambiar root a directorio padre |
| `Backspace` | Cerrar directorio |
| `K` / `J` | Primer/último hermano |
| `[c` / `]c` | Git anterior/siguiente |
| **Filtros** |
| `I` | Toggle filtro gitignore |
| `H` | Toggle archivos ocultos |
| `R` | Refrescar |
| `q` | Cerrar |
| `g?` | Mostrar ayuda |

---

## 🔍 Búsqueda Fuzzy (Telescope)

### Buscar Archivos
| Atajo | Descripción |
|-------|-------------|
| `,ff` | Buscar archivos |
| `,fF` | Buscar archivos (incluir ocultos) |
| `,fg` | Buscar texto en archivos (live grep) |
| `,fs` | Buscar palabra bajo cursor |
| `,f/` | Buscar en buffer actual |
| `,fb` | Cambiar buffer |
| `,fo` | Archivos recientes |
| `,fr` | Reabrir última búsqueda |

### Otras Búsquedas
| Atajo | Descripción |
|-------|-------------|
| `,fh` | Ayuda (help tags) |
| `,fk` | Ver todos los keymaps |
| `,fc` | Comandos disponibles |
| `,f:` | Historial de comandos |
| `,f?` | Historial de búsqueda |
| `,frg` | Registros |
| `,fm` | Marcadores (marks) |
| `,fj` | Lista de saltos (jumplist) |
| `,ft` | Comentarios TODO |
| `,fT` | Solo TODO/FIX/FIXME |
| `,fn` | Historial notificaciones |

---

## 💡 LSP (Servidor de Lenguaje)

### Acciones Principales
| Atajo | Descripción |
|-------|-------------|
| `,la` | Acciones de código |
| `,lR` | Renombrar símbolo |
| `,ld` | Ir a definición |
| `,lD` | Ir a declaración |
| `,lt` | Ir a definición de tipo |
| `,lh` | Ver documentación (hover) |
| `,lK` | Ayuda de firma de función |
| `,lf` | Formatear buffer |
| `,le` | Ver diagnóstico bajo cursor |
| `,lq` | Llenar location list con diagnósticos |

### LSP vía Telescope
| Atajo | Descripción |
|-------|-------------|
| `,lr` | Referencias del símbolo |
| `,li` | Implementaciones |
| `,ls` | Símbolos del documento |
| `,lS` | Símbolos del workspace |

### Info LSP
| Atajo | Descripción |
|-------|-------------|
| `,lI` | Mostrar clientes LSP activos |
| `,lm` | Abrir Mason (gestor de paquetes) |

---

## 🐛 Diagnósticos y Errores

### Navegación
| Atajo | Descripción |
|-------|-------------|
| `[d` | Diagnóstico anterior |
| `]d` | Diagnóstico siguiente |
| `gl` | Diagnósticos de línea (float) |
| `,dd` | Todos los diagnósticos (Telescope) |
| `,td` | Toggle auto-popup de diagnósticos |

### Trouble (Panel de Errores)
| Atajo | Descripción |
|-------|-------------|
| `,xx` | Toggle diagnósticos (workspace) |
| `,xd` | Toggle diagnósticos (buffer actual) |
| `,xd0` | Abrir diagnósticos del documento |
| `,xl` | Toggle location list |
| `,xq` | Toggle quickfix list |
| `,xs` | Toggle símbolos del documento |
| `,xlp` | Toggle panel LSP |
| `,xr` | Referencias LSP |

---

## 🌿 Git

### Telescope Git
| Atajo | Descripción |
|-------|-------------|
| `,gs` | 📊 Git status (archivos modificados) |
| `,gb` | 🌿 Ramas de git |
| `,gc` | 📝 Commits del repositorio |
| `,gC` | 📝 Commits del archivo actual |

### Gitsigns (Hunks/Cambios)
| Atajo | Descripción |
|-------|-------------|
| `,hs` | ✅ Stage hunk |
| `,hr` | ↩️ Reset hunk |
| `,hu` | ⏪ Deshacer stage hunk |
| `,hS` | ✅ Stage todo el buffer |
| `,hR` | ↩️ Reset todo el buffer |
| `,hp` | 👁️ Previsualizar hunk |
| `,hb` | 👤 Toggle blame de línea |
| `]h` | Siguiente hunk |
| `[h` | Hunk anterior |

### Diffview (Vista de Diferencias)
| Atajo | Descripción |
|-------|-------------|
| `,gd` | 📊 Abrir diff (vs HEAD) |
| `,gD` | ❌ Cerrar diff |
| `,gh` | 📜 Historial del archivo actual |
| `,gH` | 📜 Historial del repositorio |
| `,gf` | 📁 Toggle panel de archivos |
| `,gF` | 📁 Enfocar panel de archivos |

---

## 🔧 Debugging (DAP)

### Breakpoints
| Atajo | Descripción |
|-------|-------------|
| `,db` | 🔴 Toggle breakpoint |
| `,dB` | 🔵 Breakpoint condicional |
| `,dL` | 📝 Logpoint |

### Controles de Debug
| Atajo | Descripción |
|-------|-------------|
| `,dc` | ▶️ Iniciar/continuar |
| `,dn` | ⏭️ Step over |
| `,di` | ⬇️ Step into |
| `,do` | ⬆️ Step out |
| `,dr` | 💻 Toggle REPL |
| `,dl` | 🔄 Ejecutar último |
| `,dt` | ⏹️ Terminar |

### UI de Debug
| Atajo | Descripción |
|-------|-------------|
| `,du` | 🖥️ Toggle UI de debugger |
| `,de` | 🔍 Evaluar expresión |
| `,dv` | 👁️ Hover eval |

### Debug Go
| Atajo | Descripción |
|-------|-------------|
| `,dgt` | 🧪 Debug test actual |
| `,dgl` | 🧪 Debug último test |

---

## 📋 Buffers y Pestañas

| Atajo | Descripción |
|-------|-------------|
| `Tab` | ➡️ Buffer siguiente |
| `Shift+Tab` | ⬅️ Buffer anterior |
| `,bp` | 🔤 Elegir buffer por letra |
| `,bc` | ❌ Cerrar buffer actual |
| `,bo` | 🗑️ Cerrar otros buffers |
| `,br` | ➡️🗑️ Cerrar buffers a la derecha |
| `,bl` | ⬅️🗑️ Cerrar buffers a la izquierda |
| `,b>` | ➡️ Mover buffer a la derecha |
| `,b<` | ⬅️ Mover buffer a la izquierda |
| `,bsd` | 📁 Ordenar por directorio |
| `,bse` | 📄 Ordenar por extensión |

---

## 💻 Terminal

### Atajos Principales
| Atajo | Descripción |
|-------|-------------|
| `,T` | Toggle terminal inferior (nativo) |
| `Ctrl+\` | Toggle último terminal (toggleterm) |
| `,t1` a `,t9` | Toggle terminal 1-9 |
| `,tq` | Cerrar todos los terminales |

### Dentro del Terminal
| Atajo | Descripción |
|-------|-------------|
| `Esc` | 🚪 Salir del modo terminal |
| `Ctrl+h/j/k/l` | ⬅️⬇️⬆️➡️ Moverse a otra ventana |

---

## 🪟 Gestión de Ventanas

### Navegación entre Ventanas
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+h` | ⬅️ Ventana izquierda |
| `Ctrl+j` | ⬇️ Ventana inferior |
| `Ctrl+k` | ⬆️ Ventana superior |
| `Ctrl+l` | ➡️ Ventana derecha |

También: `Ctrl+w` + flechas

### Redimensionar Ventanas
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+↑` | ⬆️ Aumentar altura |
| `Ctrl+↓` | ⬇️ Disminuir altura |
| `Ctrl+←` | ⬅️ Disminuir anchura |
| `Ctrl+→` | ➡️ Aumentar anchura |

💡 **Tip:** También puedes arrastrar los bordes con el ratón

### Soft Wrap (Ajuste de Línea)
| Atajo | Descripción |
|-------|-------------|
| `,tw` | Toggle soft-wrap |
| `,w8` | Ajustar a 80 columnas |
| `,w0` | Ajustar a 100 columnas |
| `,w2` | Ajustar a 120 columnas |

---

## 🧭 Navegación de Código

### Referencias (Illuminate)
| Atajo | Descripción |
|-------|-------------|
| `]]` | Siguiente referencia |
| `[[` | Referencia anterior |

### Flash (Salto Rápido)
| Atajo | Descripción |
|-------|-------------|
| `s` | ⚡ Saltar a ubicación |
| `S` | 🌳 Selección treesitter |
| `r` | 📡 Operación remota (en operator mode) |
| `R` | 🔍 Búsqueda treesitter (operator/visual) |
| `Ctrl+s` (en búsqueda) | 🔄 Toggle Flash en búsqueda |

### Harpoon (Marcadores de Archivos)
| Atajo | Descripción |
|-------|-------------|
| `,ma` | ➕ Añadir archivo actual |
| `,mm` | 📋 Toggle menú rápido |
| `,mn` | ➡️ Siguiente item |
| `,mp` | ⬅️ Item anterior |
| `,m1` a `,m5` | Seleccionar item 1-5 |

### Comentarios TODO
| Atajo | Descripción |
|-------|-------------|
| `]t` | Siguiente TODO |
| `[t` | TODO anterior |

---

## ✏️ Edición de Código

### Comentarios
| Atajo | Descripción |
|-------|-------------|
| `,/` | Toggle comentario (línea o selección) |
| `gcc` | Toggle comentario línea actual |
| `gbc` | Toggle comentario bloque actual |
| `gc` (visual) | Toggle comentario (línea) |
| `gb` (visual) | Toggle comentario (bloque) |
| `gco` | Insertar comentario abajo |
| `gcO` | Insertar comentario arriba |
| `gcA` | Comentar al final de línea |

### Formato y Lint
| Atajo | Descripción |
|-------|-------------|
| `,cf` | 🎨 Formatear archivo (conform.nvim) |
| `,lf` | 🎨 Formatear con LSP |
| `,ll` | 🔍 Ejecutar linter |

### Edición General
| Atajo | Descripción |
|-------|-------------|
| `<` (visual) | ⬅️ Reducir indentación (mantener selección) |
| `>` (visual) | ➡️ Aumentar indentación (mantener selección) |
| `Alt+j` | ⬇️ Mover línea abajo |
| `Alt+k` | ⬆️ Mover línea arriba |
| `Alt+j` (visual) | ⬇️ Mover selección abajo |
| `Alt+k` (visual) | ⬆️ Mover selección arriba |
| `p` (visual) | 📋 Pegar sin copiar texto reemplazado |

### Autocompletado y Snippets
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+Space` | 💡 Activar autocompletado |
| `Ctrl+y` | ✅ Confirmar autocompletado |
| `Ctrl+e` | ❌ Cancelar autocompletado |
| `Ctrl+j` | ⬇️ Siguiente nodo del snippet |
| `Ctrl+k` | ⬆️ Nodo anterior del snippet |
| `,ss` | 📚 Explorar e insertar snippets |

---

## 🐹 Go

### Generación de Código
| Atajo | Descripción |
|-------|-------------|
| `,goj` | 🏷️ Añadir tags json |
| `,goy` | 🏷️ Añadir tags yaml |
| `,goe` | ⚠️ Añadir if err |
| `,goi` | 🔌 Implementar interfaz |
| `,gof` | 📝 Llenar struct |
| `,gos` | 🔀 Llenar switch |
| `,goo` | 📦 Organizar imports |
| `,goq` | 🔧 Quick fix (añadir import faltante) |

### Testing
| Atajo | Descripción |
|-------|-------------|
| `,got` | 🧪 Test función |
| `,goT` | 🧪 Test archivo |
| `,goa` | 🧪 Test paquete |
| `,goc` | 📊 Cobertura |

### Ejecutar y Debugear
| Atajo | Descripción |
|-------|-------------|
| `,gor` | ▶️ Ejecutar (busca main.go automáticamente) |
| `,god` | 🐛 Debugear (busca main.go automáticamente) |
| `,gob` | 🔨 Compilar directorio actual |

💡 **Tip:** Los comandos `,gor` y `,god` encuentran automáticamente todos los main.go en tu proyecto y te dejan elegir cuál ejecutar

---

## 🤖 Claude Code (IA)

| Atajo | Descripción |
|-------|-------------|
| `,ac` | 💬 Toggle panel de Claude |
| `,af` | 🎯 Enfocar/toggle Claude |
| `,ar` | 🔄 Reanudar sesión |
| `,aC` | ➡️ Continuar |
| `,am` | 🤖 Seleccionar modelo |
| `,ab` | ➕ Añadir buffer actual |
| `,as` (visual) | 📤 Enviar selección visual |
| `,as` (en explorador) | 📁 Añadir archivo bajo cursor |
| `,aa` | ✅ Aceptar diff |
| `,ad` | ❌ Rechazar diff |

💡 **Nota:** En exploradores de archivos (NvimTree, neo-tree, oil), `,as` añade el archivo bajo el cursor en lugar de enviar selección.

---

## 🛠️ Otras Herramientas

### Tagbar (Símbolos)
| Atajo | Descripción |
|-------|-------------|
| `,tt` | Toggle Tagbar |
| `,to` | Abrir Tagbar |

### Treesitter
| Atajo | Descripción |
|-------|-------------|
| `,ti` | 🎨 Inspeccionar highlight bajo cursor |
| `,tI` | 🌳 Inspeccionar árbol de sintaxis |
| `,tig` | 📏 Toggle guías de indentación |

### Spectre (Buscar y Reemplazar)
| Atajo | Descripción |
|-------|-------------|
| `,S` | 🔍 Buscar y reemplazar en proyecto |
| `,Sf` | 🔍 Buscar y reemplazar en archivo |
| `,Sw` | 🔍 Buscar palabra bajo cursor |
| `,S` (visual) | 🔍 Buscar y reemplazar selección |

### Sesiones (Persistence)
| Atajo | Descripción |
|-------|-------------|
| `,qs` | 💾 Restaurar sesión del directorio actual |
| `,ql` | 💾 Restaurar última sesión |
| `,qd` | 🚫 No guardar sesión actual |

### Utilidades
| Atajo | Descripción |
|-------|-------------|
| `Esc` | 🧹 Limpiar highlight de búsqueda |
| `Ctrl+s` | 💾 Guardar archivo |
| `,km` | 🗺️ Explorar keymaps personalizados |

---

## 💡 Tips y Trucos

### 🔍 Búsqueda de Atajos
- Usa `,fk` o `:Telescope keymaps` para buscar cualquier atajo interactivamente
- Escribe parte del comando que buscas y Telescope lo filtrará

### 🖱️ Uso del Ratón
- **Click en ventanas** para cambiar el foco
- **Arrastra los bordes** para redimensionar ventanas
- **Scroll** con la rueda del ratón
- **Selecciona texto** con el ratón

### 💻 Terminal
- Presiona `Esc` para salir del modo terminal
- Usa `Ctrl+h/j/k/l` para navegar a otras ventanas desde el terminal
- Usa `Ctrl+\` para toggle rápido del último terminal
- Accede a terminales específicos con `,t1`, `,t2`, etc.

### 🌿 Git Workflow
1. `,gs` - Ver archivos modificados
2. `,hp` - Previsualizar cambios
3. `,hs` - Stage hunks individuales
4. `,gd` - Ver diff completo

### 🐛 Debugging
1. `,db` - Poner breakpoint
2. `,dc` - Iniciar debug
3. `,du` - Abrir UI de debug
4. `,dn/di/do` - Navegar por el código

### 🐹 Go Development
- Usa `,gor` para ejecutar cualquier main.go de tu proyecto
- Usa `,god` para debugear con soporte automático de .env.local
- Usa `,got` para ejecutar el test bajo el cursor

---

**📚 ¿Necesitas más ayuda?**
- Ejecuta `:help` para la documentación de Neovim
- Usa `,fh` para buscar en la ayuda con Telescope
- Visita la configuración en `~/.config/nvim/lua/apascualco/keybinding.lua`
