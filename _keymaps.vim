" Key maps.
"   To find what's using a key map:
"     :verbose nmap <leader>b

" Leader.
let mapleader=' '
set timeoutlen=3000

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

"   Expand and jump (expand is higher priority).
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Normal.
nnoremap <C-n> :call CocAction('diagnosticNext')<CR>
nnoremap <C-p> :call CocAction('diagnosticPrevious')<CR>
nnoremap <Esc> :nohlsearch<CR><Esc>
nnoremap <Down> :cnext<CR>
nnoremap <Up> :cprevious<CR>
nnoremap <Leader>a :Ag<Space>
nnoremap <Leader>g :call CocAction('jumpDefinition')<CR>
nnoremap <Leader>i :G<Space>
nnoremap <Leader>o :GFiles<CR>

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
tnoremap <silent> <M-r> <C-\><C-n>:RnvimrResize<CR>
