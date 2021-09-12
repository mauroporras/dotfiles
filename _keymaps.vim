" Key maps.
"   To find what's using a key map:
"     :verbose nmap <leader>b

" Leader.
let mapleader=' '

" Command line (:h mapmode-c).
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-f> <Right>

" Terminal (:h mapmode-t).
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" Insert.
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-e> <End>
inoremap <C-f> <Right>

" Normal.
nnoremap <Esc> :nohlsearch<CR><Esc>
nnoremap <Down> :cnext<CR>
nnoremap <Up> :cprevious<CR>
nnoremap <Leader>a :Rg<Space>
nnoremap <Leader>i :G<Space>
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>S :GFiles?<CR>
"   CoC.
"     Expand and jump (expand is higher priority).
imap <C-j> <Plug>(coc-snippets-expand-jump)
nmap <C-n> <Plug>(coc-diagnostic-next)
nmap <C-p> <Plug>(coc-diagnostic-prev)
nmap <Leader>E :CocRestart<CR>
nmap <Leader>gd <Plug>(coc-definition)
nmap <Leader>gr <Plug>(coc-references)
nmap <Leader>gR <Plug>(coc-rename)

"   Tabs.
nnoremap <Leader>tt :$tabnew<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>th :-tabmove<CR>
nnoremap <Leader>tl :+tabmove<CR>

nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>yt :BTags<CR>
nnoremap <Leader>zh :History<CR>
nnoremap <Leader>zl :Lines<CR>
nnoremap <Leader>zm :Marks<CR>
nnoremap <Leader>zt :Tags<CR>

"   Buffers.
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>d :bdelete<CR>
nnoremap <Leader>e :edit!<CR>
nnoremap <Leader>l :edit #<CR>
nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>p :bprevious<CR>
nnoremap <Leader>q <C-w>q
nnoremap <Leader>s :wall<CR>

"   Ranger.
nnoremap <Leader>r :RnvimrToggle<CR>
tnoremap <M-r> <C-\><C-n>:RnvimrResize<CR>

"   vim-which-key.
nnoremap <Leader> :WhichKey '<Space>'<CR>
