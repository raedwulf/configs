" 
" Raedwulf's .vimrc
" Nick: Raedwulf
" Mail: tcmreastwood@gmail.com
"

" {{{ Key Mappings
" Leader
let mapleader=","

" {{{ Window/split navigation
nmap <Esc>h <C-w>h
nmap <Esc>j <C-w>j
nmap <Esc>k <C-w>k
nmap <Esc>l <C-w>l
nmap <Esc>n <C-w>W
nmap <Esc>t <C-w>w
" }}}

" {{{ Basic shortcuts
" Handy shortcut for save
noremap <Leader>e e
noremap <silent> e :w<CR>

" Meta-o for inserting a blank line
noremap <Esc>o o<Esc>

" O mappings for not inserting the comment leader
noremap go o<Esc>S
noremap gO O<Esc>S

" To prevent annoying mispresses
vmap K k
nmap Q <Nop>

" Use ,, to work around , as leader
noremap ,, ,

" Return to visual mode after indenting
vmap < <gv
vmap > >gv

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Search for word under cursor without moving
noremap <Leader># #*
noremap <Leader>* *#

" Quickly send keys to a screen session through slime.vim
" Allows for test-execution of scripts and whatnot without leaving vim.
nmap <C-c>m :call Send_to_Screen("<C-v>")<CR>
nmap <C-c>c :call Send_to_Screen("<C-v>OA<C-v>")<CR>
nmap <C-c>r :call Send_to_Screen(input("send to screen: ")."<C-v>")<CR>
nmap <C-c>g :call Send_to_Screen(input("send to screen: "))<CR>

" }}}

" {{{ Spellcheck
nmap <Leader>ss :set nospell<CR>
nmap <Leader>se :set spell spelllang=en<CR>
nmap <Leader>sn :set spell spelllang=nl<CR>
" }}}

" {{{ Buffer Navigation
nnoremap <silent> <Esc>c :A<CR>
nnoremap <silent> <Esc>g :IncBufSwitch<CR>
nnoremap <silent> <Esc>b :e .<CR>

nnoremap <silent> <Esc>x :bnext<CR>
nnoremap <silent> <Esc>v :bprev<CR>
" }}}

" {{{ Opening different plugin windows
nmap <silent> <Leader>n :NERDTreeToggle<CR>
nmap <silent> <Leader>t :TlistToggle<CR>
nmap <Leader>h :vert bo help 
" }}}

" {{{ Command line cursor keys
cnoremap <C-H> <Left>
cnoremap <C-L> <Right>
cnoremap <C-X> <Delete>
cnoremap <C-J> <Down>
cnoremap <C-K> <Up>
cnoremap <Esc>j <Down>
cnoremap <Esc>k <Up>
cnoremap <Esc>c <C-c>:
" }}}

" {{{ Function key shortcuts
" F5: Toggle paste mode
nnoremap <F5> :set paste!<Bar>set paste?<CR>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" F6: Toggle whether to use textwidth or not
nnoremap <F6> :call TextwidthToggle()<CR>
imap <F6> <C-O><F6>

" F7: Turn search highlight off until next search
nmap <F7> :noh<CR>
imap <F7> <C-O><F7>

" F8: Toggle list mode
nmap <F8> :set list!<Bar>set list?<CR>
imap <F8> <C-O><F8>

" F9: Toggle highlighting long lines
nmap <F9> :call HighlightLongToggle()<CR>
imap <F9> <C-O><F9>

" F10: Rebuild ctags
map <F10> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f .tags .<CR>

" }}}
" }}}

" {{{ Plugin Settings
" NERD Commenter
let NERDDefaultNesting = 1

" NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$', '\.o$']
let NERDTreeSortOrder = ['\/$', '\.[ch]$', '\.py$', '*']

" Supertab
let g:SuperTabDefaultCompletionType = 'context'

" Taglist
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1

" Pydoc
let g:pydoc_highlight = 0

" Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0

" Buffer tabs in statusline
let g:buftabs_in_statusline = 1
let g:buftabs_active_highlight_group = "Visual"
let g:buftabs_only_basename = 1

" Use fancy css for TOhtml
let html_use_css = 1

" }}}

" {{{ Vim Settings

" Don't be vi compatible
set nocompatible

" Setup mouse for xclip and scrolling
if has('mouse')
    set mouse=av
endif

" Color Schemes
if $TERM == 'linux'
    " Virtual Console
    colorscheme default
else
    " Regular
    set t_Co=256
    "colorscheme oblivion
    colorscheme desert256
endif
  
" Config
" Use UTF-8 encoding
set encoding=utf-8

" Don't highlight the current line
set nocursorline

" Characters to use in list mode
set listchars=eol:$,tab:>-,trail:·

" Enter tabs when tab is pressed:
set noexpandtab
	
" Always display statusline
set laststatus=2

" Text width
let g:textwidth=0
set textwidth=0

" Wrap lines
set wrap

" Use 8 spaces to represent a tab
set tabstop=8
set softtabstop=8

" Number of spaces to use for auto indent
set shiftwidth=8

" Copy indent from current line when starting a new line
set autoindent

" Load cindent
set cindent

" Makes the backspace key more powerful
set backspace=indent,eol,start

" Shows the match while typing
set incsearch

" Case insensitive search
set ignorecase
set smartcase

" Show line and column number
set number
set ruler
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Allow hidden buffers with changes
set hidden

" Automatically switch to the directory we're editing in
if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif
    

" Show matching
set showmatch

" Remember history
set history=200

" Scrolloff
set scrolloff=3

" Shortmess
set shortmess=atI

" Allow backup
set backup

" Swap files
set backupdir=~/tmp,/var/tmp,/tmp
set directory=~/tmp,/var/tmp,/tmp

" Use actual block mode for visual block
set virtualedit=block

" Viminfo
set viminfo='1000,f1,<500,:500,/500,h

" Global match by default
set gdefault

" Format (gq) options
set formatoptions+=w

" Highlight search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" Filetype
filetype on
filetype plugin on
filetype indent on

" Syntax highlighting
syntax on

" ctags
set tags=./.tags;${HOME}

" }}}

" {{{ Autocommands
" Read-only .doc through antiword
autocmd BufReadPre *.doc silent set ro
autocmd BufReadPost *.doc silent %!antiword "%"

" Read-only odt/odp through odt2txt
autocmd BufReadPre *.odt,*.odp silent set ro
autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"

" Read-only pdf through pdftotext
autocmd BufReadPre *.pdf silent set ro
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

" Read-only rtf through unrtf
autocmd BufReadPre *.rtf silent set ro
autocmd BufReadPost *.rtf silent %!unrtf --text

" HTML Indent
autocmd BufEnter *.html silent setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufEnter *.html silent filetype indent off
autocmd BufEnter *.html silent setlocal ai

" SASS Indent
autocmd BufEnter *.sass silent setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufEnter *.sass silent filetype indent off
autocmd BufEnter *.sass silent setlocal ai

" Don't show space errors
autocmd BufEnter *.py hi pythonSpaceError ctermbg=black

" Highlight long lines
autocmd BufRead * let w:longmatch = matchadd('StatusLine', '\%<81v.\%>77v', -1)
autocmd BufRead * let w:toolongmatch = matchadd('IncSearch', '\%>80v.\+', -1)

" Jump to last known cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Detect the indentation of current file
"autocmd BufReadPost * :DetectIndent
"autocmd BufReadPost * :let g:detectindent_preferred_expandtab = 8
"autocmd BufReadPost * :let g:detectindent_preferred_indent = 8
" }}}

" {{{ Functions
" {{{ TextwidthToggle(): Change textwidth, 0<->78
function! TextwidthToggle()
    if g:textwidth == 0
        let g:textwidth = 78
        set textwidth=78
    else
        let g:textwidth = 0
        set textwidth=0
    endif

    set textwidth?
endfunction

function! HighlightLongToggle()
    if exists('w:longmatch')
        call matchdelete(w:longmatch)
        call matchdelete(w:toolongmatch)
        unlet w:longmatch
        unlet w:toolongmatch
        echo "  don't highlight long"
    else
        let w:longmatch = matchadd('StatusLine', '\%<81v.\%>77v', -1)
        let w:toolongmatch = matchadd('IncSearch', '\%>80v.\+', -1)
        echo "  highlight long"
    endif
endfunction
" }}}
" }}}
" vim:fdm=marker
