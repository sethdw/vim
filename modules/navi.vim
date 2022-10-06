" KEYBINDS FOR NAVIGATING BUFFERS, LINES ETC

" Navigation leader key as space
nnoremap <space> <Nop>
" let navileader=<space>

" Ctrl+F to fuzzy search all lines
map <C-F> :Lines<CR> 
" Mouse on normal mode
set mouse=nc

" buffer navigation
nnoremap <C-h> :Buffers<CR>
map <C-O> :Files<CR> 
map <C-Y> :Files ~<CR>
map <C-L> :Lines<CR> 

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
