" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
" I like using H and L for beginning/end of line
nmap H ^
nmap L $
" Quickly remove search highlights
nmap <F9> :nohl
nmap <F5> :nohl

" Yank to system clipboard
set clipboard=unnamed


" ===========================
" Basics
" ==========================
set hlsearch
set shell=$SHELL
set backspace=indent,eol,start

" don't need to press escape key
inoremap jk <Esc>
cnoremap jk <Esc>

" ===========================
" misc
" ===========================

" Emulate Original gt and gT https://vimhelp.org/tabpage.txt.html#gt
exmap nextTab obcommand workspace:next-tab
exmap prevTab obcommand workspace:previous-tab
nmap gt :nextTab
nmap gT :prevTab

" Emulate Original Folding command https://vimhelp.org/fold.txt.html#fold-commands
exmap unfoldall obcommand editor:unfold-all
exmap togglefold obcommand editor:toggle-fold
exmap foldall obcommand editor:fold-all
exmap foldless obcommand editor:fold-less
exmap foldmore obcommand editor:fold-more
nmap zo :togglefold
nmap zc :togglefold
nmap za :togglefold
nmap zm :foldmore
nmap zM :foldall
nmap zr :foldless
nmap zR :unfoldall

" spell check
exmap contextMenu obcommand editor:context-menu
nmap z= :contextMenu
vmap z= :contextMenu

exmap wq obcommand workspace:close
exmap q obcommand workspace:close


" ===========================
" splits
" ===========================
nnoremap <C-J> <C-W><C-J>
nnoremap <C-H> <C-W><C-H>
nnoremap ]w <C-W><C-L>
nnoremap [w <C-W><C-H>

exmap focusRight obcommand editor:focus-right
" nmap <C-w>l :focusRight
nmap <C-L> :focusRight

exmap focusLeft obcommand editor:focus-left
nmap <C-w>h :focusLeft

exmap focusTop obcommand editor:focus-top
" nmap <C-w>k :focusTop
nmap <C-K> :focusTop

exmap focusBottom obcommand editor:focus-bottom
" nmap <C-w>j :focusBottom
nmap <C-J> :focusBottom

exmap vsplit obcommand workspace:split-vertical
nmap <C-w>v :vsplit

exmap split obcommand workspace:split-horizontal
nmap <C-w>s :split

" Yank to system clipboard
set clipboard=unnamed
set tabstop=4
