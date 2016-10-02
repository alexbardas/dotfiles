" Drop compatibility with vi
set nocompatible

" Keep swap and backup files in /.vim directory
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set undodir=~/.vim/undo
set backup
set shell=/bin/sh

set autoindent                  " Copy indent from last line when starting new line
set background=dark             " Dark background
set backspace=indent,eol,start  " Allow backspacing in insert mode
set cursorline                  " Highlight current line
set encoding=utf-8 nobomb       " BOM often causes trouble
set expandtab                   " Convert tabs to spaces
set foldenable                  " Enable folding
set foldlevelstart=10           " Open most folds by default
set foldnestmax=10              " 10 nested fold max
set hidden                      " Hide buffers instead of closing them
set history=10000               " Keep a longer history
set hls                         " Highlight search terms
set ignorecase                  " Ignore upper/lower case when searching
set incsearch                   " Search as characters are entered
set laststatus=2                " Always show status line
set lazyredraw                  " Don't redraw when we don't have to
set mouse=a
set noerrorbells                " Disable error bells
set noshowmode                  " Don't show the current mode (airline.vim takes care of us)
set ofu=syntaxcomplete#Complete " Omni-completion method
set number                      " Show line number
set ruler                       " Show position of cursor in status line
set scrolloff=3                 " Maintain more context around the cursor
set shiftwidth=2                " Shift width 2 spaces (for auto indent)
set showmatch                   " Show matching brackets
set showtabline=2               " Always show tab bar
set softtabstop=2               " Number of spaces in <TAB> when editing
set splitright                  " Open a new file in the vertical split on the right side
set tabstop=2                   " Number of visual spaces per <TAB>
set title                       " Set window title
set undolevels=10000            " Keep a longer undo history
set visualbell                  " Mute bell
set wildmenu                    " Visual autocomplete for command menu
set wildmode=list:longest       " Make completion more like bash
set wrapscan                    " Searches wrap around end of file
filetype plugin indent on       " Special indentation rules for file type
syntax on                       " Color syntax

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
"setlocal omnifunc=necoghc#omnifunc

let g:jsx_ext_required = 0 " Allow JSX in normal JS files
let g:syntastic_javascript_checkers = ['standard']

" Configuration -------------------------------------------------------------
let mapleader = "\<Space>"

" Copy & paste to system clipboard with <Space>p and <Space>y {{{
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
" }}}

" Tab navigation
map <S-Right> :tabn<CR>
map <S-Left>  :tabp<CR>

" Remap arrow keys to nothing
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Jump to the next visible line in the editor (useful for wrapped lines)
nnoremap j gj
nnoremap k gk

" Clear highlight searches by using /
nmap <silent> <Leader>/ :nohlsearch<CR>

" Region expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" FastEscape {{{
" Speed up transition from modes
if !has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif
" }}}

" Change Cursor when entering Insert Mode {{{
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
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

" Disable automatic comment insertion
augroup Format-Options
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Filetypes -------------------------------------------------------------
" JavaScript {{{
augroup filetype_javascript
  autocmd!
  let g:javascript_conceal = 1
augroup END
" }}}

" JSON {{{
augroup filetype_json
  autocmd!
  command PrettyJSON :%!python -m json.tool
augroup END
" }}}

" Plugin Configuration -------------------------------------------------------------

" Airline.vim {{{
augroup airline_config
  autocmd!
  let g:airline#extensions#syntastic#enabled = 1
  let g:airline#extensions#tabline#buffer_nr_format = '%s '
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamecollapse = 0
  let g:airline#extensions#tabline#fnamemod = ':t'

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.whitespace = 'Ξ'

augroup END
" }}}

" CtrlP.vim {{{
augroup ctrlp_config
    autocmd!
    let g:ctrlp_cmd = 'CtrlPMixed'          " Search in Files, Buffers and MRU files at the same time
    let g:ctrlp_clear_cache_on_exit = 0     " Do not clear filenames cache, to improve CtrlP startup
    let g:ctrlp_lazy_update = 200           " Set delay to prevent extra search
    let g:ctrlp_match_func = {
    \ 'match': 'pymatcher#PyMatch'
    \ }                                     " Use python fuzzy matcher for better performance
    let g:ctrlp_match_window_bottom = 0     " Show at top of window
    let g:ctrlp_max_files = 0               " Set no file limit, we are building a big project
    let g:ctrlp_switch_buffer = 'Et'        " Jump to tab AND buffer if already open
    let g:ctrlp_open_new_file = 'r'         " Open newly created files in the current window
    let g:ctrlp_open_multiple_files = 'ij'  " Open multiple files in hidden buffers, and jump to the first one
    let g:ctrlp_working_path_mode = 'ra'    " Set the local working directory the nearest ancestor containing .git

    nmap <C-b> :CtrlPBuffer<CR>

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
    else
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
        let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
        \ }
    endif
augroup END
" }}}

" EasyMotion {{{
augroup easymotion_config
  autocmd!
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  nmap <Leader>s <Plug>(easymotion-s2)
  nmap <Leader>t <Plug>(easymotion-t2)
  nmap <Leader>w <Plug>(easymotion-w)
  nmap <Leader>e <Plug>(easymotion-e)
  nmap <Leader>b <Plug>(easymotion-b)
augroup END
" }}}

" Ctrlsf {{{
augroup ctrlsf_config
  autocmd!
  let g:ctrlsf_default_root = 'project'
  let g:ctrlsf_position = 'top'
  nmap <C-F>f <Plug>CtrlSFPrompt
  vmap <C-F>f <Plug>CtrlSFVwordPath
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

" Nerdtree {{{
augroup nerdtree
  autocmd!
  " Automatically open NerdTree at startup
  " autocmd VimEnter * NERDTree
  " Go to previous (last accessed) window
  " autocmd VimEnter * wincmd p
  " Close vim if the only tab opened is NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  let g:NERDTreeWinSize = 20
augroup END
" }}}

" Nerdtree Git Plugin {{{
augroup nerdtree_git_plugin_config
  autocmd!
  let g:NERDTreeIndicatorMapCustom = {
  \ "Modified"  : "✹",
  \ "Staged"    : "✚",
  \ "Untracked" : "✭",
  \ "Renamed"   : "➜",
  \ "Unmerged"  : "═",
  \ "Deleted"   : "✖",
  \ "Dirty"     : "✗",
  \ "Clean"     : "✔︎",
  \ "Unknown"   : "?"
  \ }
augroup END
" }}}

" Flow {{{
augroup flow_config
  autocmd!
  let g:flow#autoclose = 1
augroup END
" }}}

" vim-javascript {{{
augroup vim_javascript_config
  autocmd!
augroup END
" }}}

" Investigate {{{
augroup investigate_config
  autocmd!
  let g:investigate_use_dash = 1
  nnoremap docs :call investigate#Investigate('n')<CR>
  vnoremap docs :call investigate#Investigate('v')<CR>
augroup END
" }}}

" Plugins -------------------------------------------------------------

" Load plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'ap/vim-css-color'
Plug 'bling/vim-airline'
Plug 'blueyed/vim-diminactive'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'editorconfig/editorconfig-vim'
Plug 'facebook/vim-flow'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'junegunn/vim-emoji'
Plug 'keith/investigate.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'majutsushi/tagbar'
Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }
Plug 'mxw/vim-jsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'othree/yajs.vim'
Plug 'pangloss/vim-javascript'
Plug 'Raimondi/delimitMate'
Plug 'ryanss/vim-hackernews'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'SirVer/ultisnips'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomasr/molokai'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'Valloric/MatchTagAlways'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --gocode-completer' }
Plug 'Xuyuanp/nerdtree-git-plugin'
call plug#end()
" }}}

color molokai
