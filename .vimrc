"Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
Plug 'tpope/vim-surround'
Plug 'drewtempelmeyer/palenight.vim'

" syntax
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
call plug#end()

"Basic setup
set autoread "update automatically when file is modified externally
filetype plugin on
filetype indent on
set wildmenu
syntax on
set mouse=a
set hlsearch   "Highlight results
set incsearch  "Search next

"Setup tabs
set tabstop=2     "2-space tabs
set shiftwidth=2  "2-space tabs
set expandtab     "Use space-based tabs
set smarttab      "Smart tabs
set autoindent    "Auto indent
set smartindent   "Smart indent C-like syntax

"Setup appearance
syntax enable
set number          "Enable line numbers
set cursorline      "Highlight current line
set ruler           "Always show current position
set showmatch       "Show matching brackets under cursor
set mat=2           "How long to flash matching brackets in 1/10sec

"truecolor support
if (has("termguicolors"))
  set termguicolors
endif

"Theme
set background=dark
colorscheme palenight 

"Extra syntax
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

