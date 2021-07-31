local opt = vim.opt
local g = vim.g

opt.number = true
opt.relativenumber = true
opt.guifont = "Meslo LG S for Powerline"
-- opt.spell = true
opt.colorcolumn = "120"
opt.tabstop = 4 
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true
opt.shiftwidth = 4
opt.expandtab = true
opt.scrolloff = 8
opt.updatetime = 300

opt.ic = true

opt.list = true 
opt.listchars = { eol='¬',tab='>·',trail='~',extends='>',precedes='<',space='.' }
opt.background="dark"

vim.cmd [[set noerrorbells noswapfile nofixendofline nowrap nobackup]]

g.NERDTreeShowHidden = 1
g.airline_powerline_fonts = 1
g["airline#extensions#tabline#enabled"] = 1

g.floaterm_height = 0.9
g.floaterm_width = 0.9

g.gitgutter_map_keys = 0
g.gitgutter_enable = 1

g.floaterm_keymap_new = '<Leader>fn'
g.floaterm_keymap_toggle = '<Leader>ft'
g.floaterm_keymap_prev   = '<Leader>fp'

-- HardTime
g.hardtime_default_on = 1
g.hardtime_showmsg = 1
g.hardtime_ignore_quickfix = 1
g.hardtime_ignore_buffer_patterns = [[ "NERD.*" ]]

