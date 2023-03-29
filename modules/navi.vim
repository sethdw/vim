" KEYBINDS FOR NAVIGATING BUFFERS, LINES ETC

" Navigation leader key as space
nnoremap <space> <Nop>
" let navileader=<space>

" Ctrl+F to fuzzy search all lines
map <C-F> :FzfLua lines<CR> 

" Mouse on normal mode
" Do with remapping to use smooth scrolling plugins
set mouse=nc
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" C-J & C-K to C-Y and C-E
map <C-K> 6k \| <C-Y>
map <C-J> 6j \| <C-E>

" buffer navigation
nnoremap <C-h> :FzfLua buffers<CR>
map <C-O> :FzfLua files<CR> 

" easymotion
" Priority of keys goes left to right, unless it's a leader key then it's
" right to left which is daft. 
" This layout means the leader key will almost always be one of ont. Also I 
" haven't included gj because they're a pain to hit.
let g:EasyMotion_keys='arsdheiqwfpluy;zxcvbkmtno'
map <space>f <Plug>(easymotion-bd-f2)
map <space>t <Plug>(easymotion-bd-jk)
map <space>w <Plug>(easymotion-bd-wl)
map <space>k <Plug>(easymotion-k)
map <space>j <Plug>(easymotion-j)

