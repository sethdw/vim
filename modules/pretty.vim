" #### #### PRETTY #### #### "
let base16colorspace=256
set number
syntax enable
colorscheme one

" Smooth scrolling
lua require('neoscroll').setup()

" Tmux rubbish for vim
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum

" Tmux rubbish for nvim (assumes tmux > 2.2)
"Credit joshdick
if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
    set termguicolors
endif

" Tabs
let g:airline#extensions#tabline#enabled = 1

" powerline symbols
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.colnr = ' C:'
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' L:'
let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.dirty='⚡'
