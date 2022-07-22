" #### #### PLUGINS #### #### "
call plug#begin('~/.config/nvim/plugged')

" Status Bar
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'

" Navigation
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'

" Tools
Plug 'neomake/neomake'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'

" Pretty
Plug 'kyazdani42/nvim-web-devicons'
Plug 'EdenEast/nightfox.nvim'
Plug 'ap/vim-css-color'

call plug#end()

" #### #### TOOLS #### #### "
filetype plugin indent on
filetype indent on
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4
set autoread
set wildmenu
set relativenumber
set cursorline
set wildmenu

" Indent Highlights
let g:indentLine_char = '│'
set list
set lcs=tab:\┆\ ,trail:⎵
set colorcolumn=80

" Linting
let g:python3_host_prog = '/usr/bin/python3'
call neomake#configure#automake('rnw')
let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_open_list = 2
let g:neomake_python_pylint_maker = {"args": ['-d C,R,W']}

" Git
let g:fugitive_git_executable = '/tools/ctools/git/2.25.0/bin/git'

" #### #### PRETTY #### #### "
source $HOME/.config/nvim/modules/pretty.vim

" #### #### KEYBINDS #### #### "
" Navigation
source $HOME/.config/nvim/modules/navi.vim

" Set leader key to backslash
let mapleader = "\\"

" Double tap n to exit insert mode
inoremap <nowait> nn <esc>

" toggle 'make vim normal'
nnoremap <leader>n :set relativenumber!<CR>

" toggle line numbers (for copying)
nnoremap <leader>c :set relativenumber!\|:set number!<CR>

" Open/reload vimrc
nnoremap <leader>r :so $MYVIMRC<CR>
nnoremap <leader>v :e $MYVIMRC<CR>

" F5 inserts dd/mm/yyyy
nnoremap <F5> "=strftime("%d/%m/%Y")<CR>P
inoremap <F5> <C-R>=strftime("%d/%m/%Y")<CR>

autocmd BufEnter *.hcs :setlocal filetype=python
autocmd BufEnter *.tccl :setlocal filetype=python
