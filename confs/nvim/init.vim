" clear all autocommands (should wrap things in augroups though soon)
autocmd!

" ##### vim-plug manager #####
call plug#begin('~/.config/nvim/plugged')

" ## Auto-Completion and Linting
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'w0rp/ale'

" testing...
"Plug 'neomake/neomake'
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

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
colorscheme monokai_pro
syntax on
" background colour
highlight Normal ctermbg=236
" line number colours
highlight LineNr ctermfg=grey ctermbg=236
" colour when there is no text
highlight NonText ctermbg=238
" bar theme

" line numbering
set nu
" Line length ruler
let &colorcolumn = 79
" sign column (Gutter) always ON, but not where it is pointless
let &signcolumn = 'yes'
autocmd FileType tagbar, nerdtree setlocal signcolumn=no


" ##### Plug Settings #####


" ## SimplyFold / FastFold / folding hot-key
nnoremap <space> za
" prevent auto-folding on save
let g:fastfold_savehook = 0


" ## NERDtree
map <C-n> :NERDTreeToggle<CR>
" NERDtree at startup if no arguments (ex. a file) given
autocmd VimEnter * if !argc() | NERDTree | endif


" ## deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 0
call deoplete#custom#option('auto_complete_delay', 150)
call deoplete#custom#option('auto_refresh_delay', 40)
" <TAB>: completion (for top result, and for manual selection)
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" ## ALE (Asynchronous Linting Engine)
let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'python': ['trim_whitespace'],
\   'elixir': ['trim_whitespace', 'mix_format']
\}
let g:ale_linters = {
\   'python': ['flake8'],
\   'elixir': [ 'credo', 'mix']
\}


" Required for operations modifying multiple buffers like rename.
"set hidden
"
"let g:LanguageClient_serverCommands = {
"\  'elixir': [
"\    '/home/geoff/.config/nvim/plugged/vim-elixirls/elixir-ls/release/language_server.sh',
"\  ],
"\ }

"nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" NeoMake
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
"call neomake#configure#automake('nrwi', 500)
"let g:neomake_python_enabled_makers = ['flake8']
"let g:neomake_elixir_enabled_makers = ['mix', 'credo', 'elixirc', 'elixir-ls']


" ###### Language Specific ######

" ## PYTHON
" path to interpreter
let g:python_host_prog = '/home/geoff/miniconda3/bin/python'
let g:python3_host_prog = '/home/geoff/miniconda3/bin/python3'
let g:python_highlight_all = 1
" ALE python environments
"let g:ale_python_flake8_executable = '/home/geoff/miniconda3/bin/flake8'
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

