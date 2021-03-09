set relativenumber
set colorcolumn=120
set guifont="Meslo LG S for Powerline"
set spell
set colorcolumn=120
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=8
set signcolumn=number

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

call plug#begin('~/.config/nvim/plugged')
	Plug 'gruvbox-community/gruvbox'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'vim-airline/vim-airline'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons', {'commit': '58e57b6'}
    Plug 'Xuyuanp/nerdtree-git-plugin'

    Plug 'airblade/vim-gitgutter'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-surround'
    Plug 'puremourning/vimspector'

    " alternative to python
    Plug 'vim-test/vim-test'
    Plug 'mtdl9/vim-log-highlighting'

    Plug 'tpope/vim-fugitive'

    Plug 'jiangmiao/auto-pairs'
call plug#end()

let g:gitgutter_map_keys = 0
let g:gitgutter_enable = 1
let g:vimspector_enable_mappings = 'HUMAN'

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

" Prefix G
" Git <fugitive> gs -> status | gf -> accept left | gj -> accept right
nmap <leader>gs :G<cr>
nmap <leader>gf :diffget //2<cr>
nmap <leader>gj :diffget //3<cr>

" Movement coc into code
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Prefix r
nmap <leader>rn <Plug>(coc-rename)

" Prefix F
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>

" Prefix T
nnoremap <leader>tt :NERDTreeFind<Esc>

" Prefix V
nmap <leader>vr :VimspectorReset<cr>
nmap <leader>ve :VimspectorEval <c-r><c-w><cr>
nmap <leader>vw :VimspectorWatch <c-r><c-w><cr>

" Commands function keys
nmap <F2> :CocCommand java.debug.vimspector.start<CR>

" Control key
nmap <c-l> :CocCommand python.enableLinting<CR>
map <c-n> :NERDTreeToggle<CR>
nmap <c-l> :CocCommand python.enableLinting<CR>
