set nocompatible " VIMproved
filetype off                  " required

" ===========================
" vim-multiple-cursors
" ===========================
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-N>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Vundle Plugin Management
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " required
Plugin 'git@github.com:kien/ctrlp.vim'
Plugin 'git@github.com:scrooloose/nerdtree'
Plugin 'git@github.com:mileszs/ack.vim'
Plugin 'git@github.com:bling/vim-airline'
Plugin 'git@github.com:pangloss/vim-javascript'
Plugin 'git@github.com:skammer/vim-css-color'
Plugin 'git@github.com:scrooloose/syntastic'
Plugin 'git@github.com:airblade/vim-gitgutter'
Plugin 'git@github.com:editorconfig/editorconfig-vim'
Plugin 'git@github.com:terryma/vim-multiple-cursors'
" Colors
Plugin 'git@github.com:flazz/vim-colorschemes'
Plugin 'git@github.com:/grod/grod-vim-colors'
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ===========================
" Basics
" ==========================

set backspace=indent,eol,start
syntax on
colorscheme Monokai
colorscheme dobdark
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
filetype plugin indent on
set number
set hidden " Allow hidden buffers
set backupdir=~/.vim-tmp/
set directory=~/.vim-tmp/

" don't need to press escape key
inoremap jk <Esc>
inoremap jk <Esc>

" ===========================
" splits
" ===========================
set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J> "Ctrl-j to move down a split
nnoremap <C-K> <C-W><C-K> "Ctrl-k to move up a split
nnoremap <C-L> <C-W><C-L> "Ctrl-l to move    right a split
nnoremap <C-H> <C-W><C-H> "Ctrl-h to move left a split

" ===========================
" misc
" ===========================
map <leader>rr :source ~/.vimrc<CR> "\rr reloads .vimrc
map <leader>wd cd %:p:h<CR>" \wd sets current file as cwd
map <leader>nt :NERDTreeToggle<CR>
nmap <leader>t :%s/\s\+$<CR>
" \bd deletes this buffer selects new buffer in window \bd deletes this buffer selects new buffer
map <leader>bq :bp<bar>sp<bar>bn<bar>bd<CR>

"char length 100
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%101v.\+/

" ===========================
" Syntastic Linting
" ===========================
map <leader>lint :SyntasticCheck
let g:syntastic_javascript_checkers = ["eslint", "jshint"]

" ===========================
" Git Gutter
" ===========================
nmap <leader>gg :GitGutterToggle<CR>
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>
nmap <Leader>hs :GitGutterStageHunk<CR>
nmap <Leader>hr :GitGutterRevertHunk<CR>
nmap [h <Plug>GitGutterPrevHunk<CR>
nmap ]h <Plug>GitGutterNextHunk<CR>

" ===========================
" Airline
" ===========================
set laststatus=2
let g:airline_detect_modified=1
let g:airline_detect_iminsert=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep='▶'
let g:airline_right_sep='◀'
let g:airline_inactive_collapse=0
let g:airline_powerline_fonts=1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ''

" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

" ===========================
" Buffer Tabbing
" ===========================
nmap [b :bp<CR>
nmap ]b :bn<CR>

" ===========================
" CtrlP
" ===========================
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](bower_components|node_modules|false|\.build|\.tmp)$'
  \ }

