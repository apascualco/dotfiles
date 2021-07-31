set nu relativenumber
set guifont="Meslo LG S for Powerline"
set spell
set colorcolumn=120
set tabstop=4 softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
set expandtab
set scrolloff=8
set updatetime=300

" Ignore case
set ic

" Disable no
set noerrorbells
set noswapfile

" Avoid last \n on nvim
set nofixendofline
set nowrap
set nobackup

" spaces, tabs, dif symbols
set list listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

call plug#begin('~/.config/nvim/plugged')
    Plug 'gruvbox-community/gruvbox'
    Plug 'vim-airline/vim-airline'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'preservim/nerdtree'
    "Plug 'ryanoasis/vim-devicons', {'commit': '58e57b6'}
    Plug 'ryanoasis/vim-devicons'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    Plug 'airblade/vim-gitgutter'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-surround'

    Plug 'mtdl9/vim-log-highlighting'

    Plug 'tpope/vim-fugitive'

    Plug 'jiangmiao/auto-pairs'
    Plug 'preservim/tagbar'
    Plug 'takac/vim-hardtime'
    
    Plug 'voldikss/vim-floaterm'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'preservim/nerdcommenter'

	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

:autocmd BufWritePost *.go !/Users/albertopascualcorpas/.dotifles/bin/golang_test.sh
":autocmd BufWritePost * !/Users/albertopascualcorpas/.dotifles/bin/golang_test.sh %:p:h/*.go

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
" NERDTree
let NERDTreeShowHidden=1

" Coc-extensions
 let g:coc_global_extensions = [
    \ 'coc-python',
    \ 'coc-json',
    \ 'coc-highlight',
    \ 'coc-go',
\ ]

" TagBar golang
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" Aireline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

" HardTime
let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1
let g:hardtime_ignore_quickfix = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]

" Floaterm
let g:floaterm_height=0.9
let g:floaterm_width=0.9

let g:gitgutter_map_keys = 0
let g:gitgutter_enable = 1

" Go syntax highlighting
"let g:go_highlight_fields = 1
"let g:go_highlight_functions = 1
"let g:go_highlight_function_calls = 1
"let g:go_highlight_extra_types = 1
"let g:go_highlight_operators = 1
"let g:go_fmt_autosave = 1
"let g:go_fmt_command = "goimports"
"let g:go_auto_type_info = 1
"function! s:build_go_files()
"  let l:file = expand('%')
"  if l:file =~# '^\f\+_test\.go$'
"    call go#test#Test(0, 1)
"  elseif l:file =~# '^\f\+\.go$'
"    call go#cmd#Build(0)
"  endif
"endfunction

" Theme configuration gruvbox
highlight ColorColumn ctermbg=0 guibg=lightgrey
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'
colorscheme gruvbox
set background=dark
" Theme config end

let mapleader=","

" Prefix B
nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bd :bd<CR>

" Prefix G
" Git <fugitive> gs -> status | gf -> accept left | gj -> accept right
nmap <leader>gs :G<cr>
nmap <leader>gf :diffget //2<cr>
nmap <leader>gj :diffget //3<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>gps :Git -c push.default=current push<cr>

nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghs <Plug>(GitGutterStageHunk)

" Movement coc into code
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Prefix K
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Prefix R
nmap <leader>rn <Plug>(coc-rename)

" Prefix T
nnoremap <leader>tt :NERDTreeFind<Esc>
nmap <silent><leader>tb :TagbarToggle<CR>

" Prefix F
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <leader>fn :FloatermNew<CR>
let g:floaterm_keymap_new = '<Leader>fn'
nnoremap <leader>ft :FloatermToggle<CR>
let g:floaterm_keymap_toggle = '<Leader>ft'
nnoremap <leader>fp :FloatermPrev<CR>
let g:floaterm_keymap_prev   = '<Leader>fp'

" Resize
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
