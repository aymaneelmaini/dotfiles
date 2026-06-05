" ============================================================================
" Minimal but Powerful Vim Configuration
" No external dependencies, LSP, or plugins - just pure vim
" ============================================================================

" Enable syntax highlighting
syntax enable
set background=dark

" ============================================================================
" SEARCH SETTINGS
" ============================================================================
set ignorecase          " Ignore case when searching
set smartcase           " Smart case - case sensitive if uppercase used
set incsearch           " Incremental search
set hlsearch            " Highlight search results
nnoremap <Esc> :nohlsearch<CR>   " Clear search highlight with Esc

" ============================================================================
" LINE NUMBERS
" ============================================================================
set number              " Show absolute line numbers
set relativenumber      " Show relative line numbers
set ruler               " Show cursor position in status line

" ============================================================================
" INDENTATION & TABS
" ============================================================================
set tabstop=4           " Tab width is 4 spaces
set shiftwidth=4        " Indent width is 4 spaces
set softtabstop=4       " Backspace treats 4 spaces as tab
set expandtab           " Use spaces instead of tabs
set autoindent          " Auto-indent new lines
set smartindent         " Smart indentation for code

" ============================================================================
" BEHAVIOR & UI
" ============================================================================
set showcmd             " Show partial commands in status line
set showmatch           " Highlight matching brackets
set matchtime=2         " Blink matching bracket for 0.2 seconds
set showmode            " Show current mode
set cursorline          " Highlight current line
set wrap                " Wrap long lines
set breakindent         " Preserve indentation when wrapping
set scrolloff=3         " Keep 3 lines visible above/below cursor
set sidescroll=5        " Scroll sideways smoothly
set splitbelow          " New split goes below current window
set splitright          " New split goes to right of current window

" ============================================================================
" BUFFERS & FILES
" ============================================================================
set hidden              " Allow hidden buffers
set undofile            " Persistent undo
set undodir=$HOME/.vim/undodir
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/swap
set encoding=utf-8      " UTF-8 encoding
set fileformat=unix     " Unix line endings

" Create backup directories if they don't exist
silent! call mkdir($HOME . '/.vim/undodir', 'p')
silent! call mkdir($HOME . '/.vim/backup', 'p')
silent! call mkdir($HOME . '/.vim/swap', 'p')

" ============================================================================
" C/C++ SPECIFIC SETTINGS
" ============================================================================
autocmd FileType c,cpp setlocal cindent
autocmd FileType c,cpp setlocal cinoptions=>4,e0,n0,f0,{0,}0,^0,:0,=0,g0,h4,p0,t0,+4,(0,)80,*90,#0
autocmd FileType c,cpp setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
autocmd FileType c,cpp setlocal formatoptions=croql
autocmd FileType c,cpp nnoremap <buffer> <LocalLeader>c I//<Esc>
autocmd FileType c,cpp vnoremap <buffer> <LocalLeader>c :s/^/\/\//g<CR>

" ============================================================================
" KEYBOARD SHORTCUTS
" ============================================================================
let mapleader = ' '
let maplocalleader = ','

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Move by visual lines when wrapping
nnoremap j gj
nnoremap k gk

" Quick save and quit
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>x :wq<CR>

" Split windows
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

" ============================================================================
" STATUS LINE
" ============================================================================
set laststatus=2
set statusline=%f\ %m%r%h%w
set statusline+=\ [%{&fileformat}]
set statusline+=\ [%{&filetype}]
set statusline+=%=
set statusline+=%l:%c\ %p%%

" ============================================================================
" COMPLETION
" ============================================================================
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest
inoremap <C-n> <C-x><C-n>      " Complete with next match
inoremap <C-p> <C-x><C-p>      " Complete with previous match

" ============================================================================
" MISCELLANEOUS
" ============================================================================
set nocompatible        " Don't be compatible with old vi
set backspace=indent,eol,start  " Allow backspacing over everything
set mouse=a             " Enable mouse support
set number              " Line numbers
set visualbell          " Visual bell instead of beeping
set noerrorbells        " No error bells
filetype on             " Detect file types
filetype indent on      " Load indent file for detected file type
filetype plugin on      " Load plugin files for detected file type

" ============================================================================
" COLORS & THEME (Minimal fallback colorscheme)
" ============================================================================
" If vim doesn't have a preferred colorscheme, use defaults
if !exists('g:colors_name')
  colorscheme default
endif

" Improve visibility of matching parentheses
highlight MatchParen ctermfg=white ctermbg=darkblue

" ============================================================================
" AUTO COMMANDS
" ============================================================================
" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Jump to last position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Set correct file types
autocmd BufNewFile,BufRead *.c set filetype=c
autocmd BufNewFile,BufRead *.h set filetype=c
autocmd BufNewFile,BufRead *.cpp set filetype=cpp
autocmd BufNewFile,BufRead *.hpp set filetype=cpp

nnoremap <Space>E :Lexplore<CR>
nnoremap <Space>e :Explore<CR>
