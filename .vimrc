" VIMproved
set nocompatible
" Required
filetype off

" ===========================
" vim-multiple-cursors
" ===========================
let g:multi_cursor_use_default_mapping=0

" vim-plug Plugin Management
call plug#begin('~/.vim/plugged')

" Commentary use `gc` motion, or `gcc` for the line `:help commentary for more`
Plug 'git@github.com:tpope/vim-commentary.git'
"
" Super handing git wrapper, also alows grepping :Ggrep
Plug 'git@github.com:tpope/vim-fugitive'
" Handy key bindings for tabbing through items
Plug 'git@github.com:tpope/vim-unimpaired'

" Autocomplete not working as of right now
" Plug 'git@github.com:Valloric/YouCompleteMe'

" find files in this project
Plug 'git@github.com:kien/ctrlp.vim'

" Syntax hilighting
Plug 'git@github.com:scrooloose/syntastic'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'git@github.com:pangloss/vim-javascript'
Plug 'heavenshell/vim-jsdoc'
Plug 'nrocco/vim-phplint'
Plug 'StanAngeloff/php.vim'
" File exploration
Plug 'git@github.com:scrooloose/nerdtree'
" Plug 'git@github.com:mileszs/ack.vim'

" Distraction free writing (unsure if I like it)
Plug 'git@github.com:junegunn/goyo.vim'

Plug 'git@github.com:bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'git@github.com:elzr/vim-json'
Plug 'git@github.com:skammer/vim-css-color'
Plug 'git@github.com:airblade/vim-gitgutter'
Plug 'git@github.com:editorconfig/editorconfig-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'atelierbram/Base2Tone-vim'
Plug 'xero/sourcerer'
Plug 'dim13/smyck.vim'
Plug 'moll/vim-node'
Plug 'elixir-lang/vim-elixir'
Plug 'cocopon/iceberg.vim'
" used to format as I type...

call plug#end()

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

map <xCSI>[62~ <MouseDown>
map <F11> :set invpaste<CR>
set pastetoggle=<F11>
set backspace=indent,eol,start
syntax on

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
autocmd InsertEnter,InsertLeave * set cul!
" enable autoread to reload any files from files when checktime is called and
" the file is changed
set autoread
" add an autocmd after vim started to execute checktime for *.js files on write
autocmd VimEnter *.js checktime
autocmd BufWritePost *.js checktime

" colors
set t_Co=256
" set background=dark
" colorscheme iceberg
" colorscheme sourcerer
" colorscheme Base2Tone_MorningLight
colorscheme smyck
"char length 100
let g:airline_theme='light'

" highlight OverLength ctermfg=white guibg=LightPink
" match OverLength /\%101v.\+/
map <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>
set mouse=a
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
set hidden " Allow hidden buffers
set backupdir=~/.vim-tmp/
set directory=~/.vim-tmp/
" Toggle highlight this line
nnoremap <Leader>cc :set cursorline! <CR>

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
" close location list
noremap <Leader>c :ccl <bar> lcl<CR>
" source vimrc
map <leader>rr :source ~/.vimrc<CR>
map <leader>nt :NERDTreeToggle<CR>
" Pretty Print
nmap <leader>pj :%!python -m json.tool<CR>

" =================================================
" For Prettier perhaps override with project specific .vimrc
" ==================================================
let g:prettier#config#single_quote = 'true'
let g:prettier#config#prose_wrap = 'preserve'
" let g:prettier#exec_cmd_path = '~/path/to/cli/prettier'
"
" ===========================
" Syntastic Linting
" ===========================
map <leader>s :SyntasticCheck

let g:syntastic_check_on_open=1
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_eslint_args = ['--fix']
let g:syntastic_javascript_eslint_exec = 'eslint'
" let g:syntastic_javascript_eslint_exec = '$(npm bin)/eslint'
" let g:syntastic_javascript_eslint_exe = '[ -f $(npm bin)/eslint ] && $(npm bin)/eslint || eslint -f compact --fix'
" Vim javascript linting plugin
let g:javascript_plugin_jsdoc = 1
" php linting
let g:syntastic_php_checkers = ["php"]
au BufRead,BufNewFile *.{json,arcconfig} set filetype=json

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
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

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
  \ 'dir':  '\v[\/](bower_components|node_modules|false|dist|\.build|\.tmp)$'
  \ }
let g:ctrlp_max_files = 0
let g:ctrlp_show_hidden = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:6,results:60'

" powerline fonts requires git: powerline/fonts.git to be setup
" set guifont=Menlo
set guifont:Cousine\ for\ Powerline

" https://github.com/StanAngeloff/php.vim
" function! PhpSyntaxOverride()
"   hi! def link phpDocTags  phpDefine
"   hi! def link phpDocParam phpType
" endfunction

" augroup phpSyntaxOverride
"   autocmd!
"   autocmd FileType php call PhpSyntaxOverride()
" augroup END
set exrc
set secure

