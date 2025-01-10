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
Plug 'alvan/vim-closetag'
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'

" ## utility
Plug 'airblade/vim-gitgutter'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-projectionist'

" ## colors / themeing
Plug 'fatih/molokai'
" Plug 'phanviet/vim-monokai-pro'
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
Plug 'avdgaag/vim-phoenix'

" ## JAVASCRIPT
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" ## GODOT
" Forked version by clktmr includes ALE support and folding.
"Plug 'calviken/vim-gdscript3'
Plug 'clktmr/vim-gdscript3'

" ## C#
Plug 'OmniSharp/omnisharp-vim'
Plug 'OrangeT/vim-csharp'
"Plug 'Robzz/deoplete-omnisharp'
"Plug 'dimixar/deoplete-omnisharp'

call plug#end()

" ##### General Vim Stuff #####
" Start in GitRepos (parent of code directories)
cd ~/git
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
colorscheme molokai
" colorscheme monokai_pro

syntax on
" background colour
" highlight Normal guibg=Grey19
highlight Normal guibg=NONE ctermbg=NONE
" line number colours
highlight LineNr guifg=grey guibg=None
" colour when there is no text
" highlight NonText guibg=Grey16
" comments
highlight Comment gui=bold,italic


" line numbering
set nu
" Line length ruler
let &colorcolumn = 79
" sign column (Gutter) always ON, but not where it is pointless
let &signcolumn = 'yes'
autocmd FileType tagbar, nerdtree setlocal signcolumn=no

" make yank copy to clipboard when lead with leader ('\' right now)
vnoremap  <leader>y  "+y

" ##### Plug Settings (and Notes) #####

" ## Auto Pairs
" Make sure pairing character settings are copied to new file buffers
autocmd BufNewFile * call AutoPairsInit()
au FileType eelixir let b:AutoPairs = AutoPairsDefine({'<%' : '%>', '<!--' : '-->'})
au FileType html let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'})

" ## Vim Surround
" Use S -> `)` or `]` (or any character) with a visual selection.

" ## UltiSnips
" Trigger configuration, don't want expand to be tab (deoplete uses)
let g:UltiSnipsExpandTrigger="<c-v>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ## vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.eex'

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
" autoclose scratch window after leaving autocomplete
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

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
\   'elixir': ['elixir-ls', 'credo', 'mix'],
\   'javascript': ['eslint'],
\   'lua': ['luacheck'],
\   'gdscript3': ['godotheadless'],
\   'cs': ['omnisharp'],
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

" ## JAVASCRIPT
" tab -> 4 spaces. Note: Use %retab to replace existing tabs with spaces.
autocmd Filetype javascript setlocal ts=4 sw=4 expandtab

" ## GODOT
" tab -> 4 spaces. Note: Use %retab to replace existing tabs with spaces.
autocmd Filetype gdscript3 setlocal ts=4 sw=4 expandtab
let g:ale_gdscript3_godotheadless_executable =
\ '/home/geoff/Godot/Godot_v3.1.1-stable_linux_headless.64'

" ## C#
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_highlight_types = 3
let g:OmniSharp_server_stdio = 1
"call deoplete#custom#option('sources', {
"	\ 'cs': ['omnisharp'],
"\})
