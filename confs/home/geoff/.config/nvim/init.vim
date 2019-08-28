" clear all autocommands (should wrap things in augroups though soon)
autocmd!

" ##### vim-plug manager #####
call plug#begin('~/.config/nvim/plugged')

" ## Auto-Completion and Linting
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'w0rp/ale'

" ## auto-insertion
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

" ## utility
Plug 'airblade/vim-gitgutter'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'scrooloose/nerdtree'

" ## colors / themeing
Plug 'phanviet/vim-monokai-pro'
Plug 'itchyny/lightline.vim'

" ## PYTHON
Plug 'kh3phr3n/python-syntax'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'Vimjas/vim-python-pep8-indent'

" ## ELIXIR
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim'
Plug 'tpope/vim-endwise'
Plug 'gasparch/vim-elixir-fold'
Plug 'GrzegorzKozub/vim-elixirls'

call plug#end()

" ##### General Vim Stuff #####
" Start in GitRepos (parent of code directories)
cd ~/GitRepos
" Write buffers when window focus is lost
au FocusLost * silent! wa
" Write buffer when switching to another buffer
set autowrite
" write swap to disk if nothing happens for a bit (default: 4000)
set updatetime=4000
" buffer screen updates instead of constantly updating
set lazyredraw
" limit number of columns looked at for syntax colouring
set synmaxcol=200
" always show at least X lines above and below cursor
set scrolloff=1
set display+=lastline
" allow backspacing through anything in normal mode
set backspace=indent,eol,start
" longer command history
set history=1000
" don't look in ALL files for autocompletion
set complete-=i
" waiting for keycode lag time (defaults 1000, 50)
set timeoutlen=1000
set ttimeoutlen=50
" leader key
let mapleader = "\\"

" ##### A E S T H E T I C S #####
" syntax highlighting
set termguicolors
colorscheme monokai_pro
syntax on
" background colour
highlight Normal guibg=Grey19
" line number colours
highlight LineNr guifg=grey guibg=None
" colour when there is no text
highlight NonText guibg=Grey16
" comments
highlight Comment gui=bold,italic


" line numbering
set nu
" Line length ruler
let &colorcolumn = 79
" sign column (Gutter) always ON, but not where it is pointless
let &signcolumn = 'yes'
autocmd FileType tagbar, nerdtree setlocal signcolumn=no


" ##### Plug Settings (and Notes) #####

" ## Auto Pairs
" Make sure pairing character settings are copied to new file buffers
autocmd BufNewFile * call AutoPairsInit()

" ## Vim Surround
" Use S -> `)` or `]` (or any character) with a visual selection.

" ## SimplyFold / FastFold / folding hot-key
nnoremap <space> za
" prevent auto-folding on save
let g:fastfold_savehook = 0


" ## NERDtree
" (NOTE: s opens file in :vsp, t opens in new tab, T opens silenty in tab)
map <C-n> :NERDTreeToggle<CR>
" NERDtree at startup if no arguments (ex. a file) given
autocmd VimEnter * if !argc() | NERDTree | endif


" ## deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 0
call deoplete#custom#option('auto_complete_delay', 100)
call deoplete#custom#option('auto_refresh_delay', 30)
" <TAB>: completion (for top result, and for manual selection)
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" ## ALE (Asynchronous Linting Engine)
let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 200
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'python': ['trim_whitespace'],
\   'elixir': ['trim_whitespace', 'mix_format']
\}
let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'elixir': ['elixir-ls', 'credo', 'mix']
\}


" ###### Language Specific ######

" ## PYTHON
" path to interpreter
let g:python_host_prog = '/home/geoff/miniconda3/bin/python'
let g:python3_host_prog = '/home/geoff/miniconda3/bin/python3'
let g:python_highlight_all = 1
" ALE python environments
let g:ale_python_flake8_executable =
\ '/home/geoff/miniconda3/envs/pytorchC10/bin/flake8'
let g:ale_python_mypy_executable =
\ '/home/geoff/miniconda3/envs/pytorchC10/bin/mypy'
let g:ale_python_mypy_ignore_invalid_syntax = 1
let g:ale_python_mypy_options = '--ignore-missing-imports'
" deoplete python
let g:deoplete#sources#jedi#enable_typeinfo = 0

" ## ELIXIR
autocmd BufWritePost *.exs,*.ex silent :!mix format %
let g:ale_elixir_elixir_ls_config = {
\   'elixirLS': {
\     'dialyzerEnabled': v:false,
\   },
\}
let g:ale_elixir_credo_strict = 1
"" Recompile the vim-elixirls copy of elixir-ls with :ElixirLsCompile
let g:ale_elixir_elixir_ls_release =
\ '/home/geoff/.config/nvim/plugged/vim-elixirls/elixir-ls/release'

