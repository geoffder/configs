" vim-plug 
call plug#begin('~/.config/nvim/plugged')

" general
Plug 'tmhedberg/SimpylFold'
Plug 'scrooloose/nerdtree' 
Plug 'Valloric/YouCompleteMe'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

" colors
Plug 'phanviet/vim-monokai-pro'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'reewr/vim-monokai-phoenix'
Plug 'sickill/vim-monokai'
Plug 'morhetz/gruvbox'

" python
Plug 'kh3phr3n/python-syntax'
Plug 'nvie/vim-flake8'

" elixir
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim'
Plug 'tpope/vim-endwise'

call plug#end()

" syntax highlighting
"colorscheme vim-monokai-tasty
"colorscheme monokai-phoenix
colorscheme monokai_pro
syntax on

" background colour
highlight Normal ctermbg=236
" line number colours
highlight LineNr ctermfg=grey ctermbg=236
" colour when there is no text
highlight NonText ctermbg=238
" bar theme
let g:airline_theme='monokai_tasty'

" line numbering
set nu

" Line length ruler
let &colorcolumn = 79

" folding
nnoremap <space> za

" NERDtree
map <C-n> :NERDTreeToggle<CR>

" YouCompleteMe (autocomplete)
let g:ycm_autoclose_preview_window_after_completion = 1

"" Language Specific
" python
let g:python_highlight_all = 1

" elixir
autocmd BufWritePost *.exs,*.ex silent :!mix format %

" Start in GitRepos (parent of code directories)
cd ~/GitRepos
