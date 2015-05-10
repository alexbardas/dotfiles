" Keep swap and backup files in /.vim directory
set backupdir=~/.vim/backup
set backup
set directory=~/.vim/tmp

syntax on                       " Color syntax
set encoding=utf-8 nobomb       " BOM often causes trouble
set smartindent                 " Use smart indent instead
set noautoindent                " Turn off autoindent by default
set tabstop=4                   " <TAB> for spaces
set shiftwidth=4                " shift width 4 spaces (for auto indent)
set expandtab                   " convert tabs to spaces
set number                      " show line number
set backspace=indent,eol,start  " Allow backspacing in insert mode
set mouse=a
set ruler                       " show position of cursor in status line
"set showmatch                   " show matching brackets
set hls                         " Highlight search terms
set incsearch                   " Highlight search terms dinamically, as you type
set ignorecase                  " ignore upper/lower case when searching
set wildmenu
set wildmode=list:longest       " Make completion more like bash
set history=1000                " Keep a longer history
set title                       " Set window title
set scrolloff=3                 " maintain more context around the cursor
set cursorline                  " Highlight current line
set visualbell                  " Mute bell
set background=dark             " Dark background
set lazyredraw                  " Don't redraw when we don't have to
set wrapscan                    " Searches wrap around end of file
filetype on                     " Filetype detection
filetype plugin indent on       " special indentation rules for file type

autocmd VimEnter * NERDTree     " Automatically open NerdTree at startup
autocmd VimEnter * wincmd p     " Go to previous (last accessed) window
" Close vim if the only tab opened is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Remove trailing whitespace and preserve position
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,ruby,python,haskell,javascript autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

"let g:jedi#popup_on_dot = 0
"let g:jedi#popup_select_first = 0

nmap <F8> :TagbarToggle<CR>
setlocal omnifunc=necoghc#omnifunc

" Configuration -------------------------------------------------------------

" FastEscape {{{
" Speed up transition from modes
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif
" }}}

" General {{{
augroup general_config
  autocmd!

  " Speed up viewport scrolling {{{
  nnoremap <C-e> 3<C-e>
  nnoremap <C-y> 3<C-y>
  " }}}

  " Faster split resizing (+,-) {{{
  if bufwinnr(1)
    map + <C-W>+
    map - <C-W>-
  endif
  " }}}

  " Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l) {{{
  map <C-j> <C-W>j
  map <C-k> <C-W>k
  map <C-H> <C-W>h
  map <C-L> <C-W>l
  " }}}

  " Sudo write (,W) {{{
  noremap <leader>W :w !sudo tee %<CR>
  " }}}

  " Get output of shell commands {{{
  command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
  " }}}

  " Remap :W to :w {{{
  command! W w
  " }}}

  " Better mark jumping (line + col) {{{
  nnoremap ' `
  " }}}

  " Hard to type things {{{
  iabbrev >> →
  iabbrev << ←
  iabbrev ^^ ↑
  iabbrev VV ↓
  iabbrev aa λ
  " }}}

  " Toggle show tabs and trailing spaces (,c) {{{
  set lcs=tab:›\ ,trail:·,eol:¬,nbsp:_
  set fcs=fold:-
  nnoremap <silent> <leader>c :set nolist!<CR>
  " }}}
  " Toggle folds (<Space>) {{{
  nnoremap <silent> <space> :exe 'silent! normal! '.((foldclosed('.')>0)? 'zMzx' : 'zc')<CR>
  " }}}

  " Fix page up and down {{{
  map <PageUp> <C-U>
  map <PageDown> <C-D>
  imap <PageUp> <C-O><C-U>
  imap <PageDown> <C-O><C-D>
  " }}}

  " Relative numbers {{{
  set relativenumber " Use relative line numbers. Current line is still in status bar.
  au BufReadPost,BufNewFile * set relativenumber
  " }}}
augroup END
" }}}

" Plugin Configuration -------------------------------------------------------------

" Airline.vim {{{
augroup airline_config
  autocmd!
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#syntastic#enabled = 1
  let g:airline#extensions#tabline#buffer_nr_format = '%s '
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamecollapse = 0
  let g:airline#extensions#tabline#fnamemod = ':t'
augroup END
" }}}

" CtrlP.vim {{{
augroup ctrlp_config
  autocmd!
  let g:ctrlp_clear_cache_on_exit = 0 " Do not clear filenames cache, to improve CtrlP startup
  let g:ctrlp_lazy_update = 350 " Set delay to prevent extra search
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' } " Use python fuzzy matcher for better performance
  let g:ctrlp_match_window_bottom = 0 " Show at top of window
  let g:ctrlp_max_files = 0 " Set no file limit, we are building a big project
  let g:ctrlp_switch_buffer = 'Et' " Jump to tab AND buffer if already open
  let g:ctrlp_open_new_file = 'r' " Open newly created files in the current window
  let g:ctrlp_open_multiple_files = 'ij' " Open multiple files in hidden buffers, and jump to the first one
augroup END
" }}}

" Silver Searcher {{{
augroup ag_config
  autocmd!

  if executable("ag")
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m

    " Have the silver searcher ignore all the same things as wilgignore
    let b:ag_command = 'ag %s -i --nocolor --nogroup'

    for i in split(&wildignore, ",")
      let i = substitute(i, '\*/\(.*\)/\*', '\1', 'g')
      let b:ag_command = b:ag_command . ' --ignore "' . substitute(i, '\*/\(.*\)/\*', '\1', 'g') . '"'
    endfor

    let b:ag_command = b:ag_command . ' --hidden -g ""'
    let g:ctrlp_user_command = b:ag_command
  endif
augroup END
" }}}

" Syntastic.vim {{{
augroup syntastic_config
  autocmd!
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_warning_symbol = '⚠'
  let g:syntastic_ruby_checkers = ['mri', 'rubocop']
augroup END
" }}}

" Molokai theme {{{
augroup molokai_config
  autocmd!

  let g:molokai_original = 1
augroup END
" }}}

" RainbowParenthesis.vim {{{
augroup rainbow_parenthesis_config
  autocmd!
  nnoremap <leader>rp :RainbowParenthesesToggle<CR>
augroup END
" }}}

" Plugins -------------------------------------------------------------

" Load plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'kien/rainbow_parentheses.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ryanss/vim-hackernews'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'airblade/vim-gitgutter'

Plug 'tomasr/molokai'

"Plug 'majutsushi/tagbar'
"Plug 'Shougo/vimproc.vim', { 'do': 'make' }
"Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --gocode-completer' }

call plug#end()
" }}}

color molokai
