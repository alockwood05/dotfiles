set nocompatible " VIMproved
filetype off                  " required

" ===========================
" vim-multiple-cursors
" ===========================
let g:multi_cursor_use_default_mapping=0

" Vundle Plugin Management
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " required
Plugin 'git@github.com:kien/ctrlp.vim'
Plugin 'git@github.com:scrooloose/nerdtree'
" Plugin 'git@github.com:mileszs/ack.vim'
Plugin 'git@github.com:dahu/vim-lotr'
Plugin 'git@github.com:junegunn/goyo.vim'
Plugin 'git@github.com:bling/vim-airline'
Plugin 'git@github.com:pangloss/vim-javascript'
Plugin 'git@github.com:jelera/vim-javascript-syntax'
Plugin 'git@github.com:skammer/vim-css-color'
Plugin 'git@github.com:scrooloose/syntastic'
Plugin 'git@github.com:airblade/vim-gitgutter'
Plugin 'git@github.com:editorconfig/editorconfig-vim'
Plugin 'git@github.com:Valloric/YouCompleteMe'
" Commentary use `gc` motion, or `gcc` for the line `:help commentary for more`
Plugin 'git@github.com:tpope/vim-commentary.git'
Plugin 'git@github.com:tpope/vim-fugitive'
" Colors
Plugin 'git@github.com:/grod/grod-vim-colors'
call vundle#end()            " required
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
filetype plugin indent on    " required
set number
set hlsearch
set mouse=a
map <xCSI>[62~ <MouseDown>
map <F11> :set invpaste<CR>
set pastetoggle=<F11>
set backspace=indent,eol,start
syntax on

" remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" colors
set background=dark
set t_Co=256
colorscheme smyck
"char length 100
highlight OverLength ctermbg=red ctermfg=white guibg=darkred
match OverLength /\%101v.\+/

set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
set hidden " Allow hidden buffers
set backupdir=~/.vim-tmp/
set directory=~/.vim-tmp/

" don't need to press escape key
inoremap jk <Esc>
cnoremap jk <Esc>

" ===========================
" splits
" ===========================
set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap ]w <C-W><C-L>
nnoremap [w <C-W><C-H>

" ===========================
" misc
" ===========================
map <leader>rr :source ~/.vimrc<CR>
map <leader>wd cd %:p:h<CR>
map <leader>nt :NERDTreeToggle<CR>

" ===========================
" Syntastic Linting
" ===========================
map <leader>lint :SyntasticCheck
let g:syntastic_javascript_checkers = ["eslint"]
hi SpellBad ctermfg=white ctermbg=red guifg=white guibg=darkred
hi SpellCap ctermfg=white ctermbg=darkred guifg=white guibg=darkred

" ===========================
" Git Gutter
" ===========================
nmap <leader>gg :GitGutterToggle<CR>
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>
" Hunk Write
nmap <Leader>hw :GitGutterStageHunk<CR>
" Hunk Undo
nmap <Leader>hu :GitGutterRevertHunk<CR>
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
" \bd deletes this buffer selects new buffer in window \bd deletes this buffer selects new buffer
map <leader>bq :bp<bar>sp<bar>bn<bar>bd<CR>

" ===========================
" CtrlP ctrlp ctrl-p
" ===========================
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](bower_components|node_modules|false|\.build|\.tmp)$'
  \ }
let g:ctrlp_max_files = 0
let g:ctrlp_show_hidden = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:30,results:30'
" ===========================
" LOTR - Lord of the regs sidebar
" ===========================
let g:lotr_position = 'left'
let g:lotr_winsize = 40
nmap <leader>r <plug>LOTRToggle<CR>


" ===========================
" Goyo - distraction free
" ===========================
let g:goyo_width = 100
let g:goyo_liner = 4
let g:goyo_margin_top = 1
let g:goyo_margin_bottom = 1
map \df :Goyo<CR>
"nmap <leader>df <plug>Goyo<CR>
