"
" Tai Chi Minh Ralph Eastwood's .vimrc
" Nick: Raedwulf
" Mail: tcmreastwood@gmail.com
"

" No compatible mode for vim
set nocompatible

" {{{ Pathogen first
" Disable bisect for now
let g:loaded_bisect=0
call pathogen#infect()
" }}}

" {{{ Key mappings
"" {{{ Convenience shortcuts
""" {{{ Mapleader
let mapleader=","
""" }}}
""" {{{ File actions
" Handy shortcut for save
nmap <silent> e :up<CR>

" Put current path in commandline
cmap ∩ <C-R>=expand("%:h")."/"<CR>

" Prompt for filetype to set
nmap <Leader>@ :call PromptFT(0)<CR>
nmap <Leader>? :call PromptFT(1)<CR>

" Close everything
nmap ZN :wqa<CR>

" Open a shell
nmap <Leader>sh :source ~/.vim/vimsh/vimsh.vim<CR>
""" }}}
""" {{{ Window navigation
nmap <Left> <C-w>h
nmap <Down> <C-w>j
nmap <Up> <C-w>k
nmap <Right> <C-w>l
nmap ☆ <C-w>w
nmap ▫ <C-w>W
nmap ,sp :vsp<CR>
nmap ,on :on<CR>
""" }}}
""" {{{ Buffer navigation
nmap <silent> ∩ :A<CR>
nmap <silent> ∪ :e .<CR>
nmap <silent> <Leader>- <C-^>

nmap <silent> » :bnext<CR>
nmap <silent> « :bprev<CR>
""" }}}
""" {{{ Editing shortcuts
" Creating new lines without comment leader
nmap go o<Esc>S
nmap gO O<Esc>S

" Return to visual mode after indenting
xmap < <gv
xmap > >gv

" Consistency!
nnoremap Y y$

" Minus to eol, since underscore is bol
nmap - $

" Use ,, for regular , (since it's the leader)
nnoremap ,, ,

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Clear screen and remove highlighting
nnoremap <silent> <C-l> :nohl<CR>

" Camel case word edit
nmap <silent> <Leader>ciw ci,w

" Toggle textwidth
nmap <Leader>/ :call TextwidthToggle()<CR>

" Toggle line numbers
nmap <Leader>c :call NuToggle()<CR>

" For deleting extra delimiters
imap œ <Del>

" Swap ` and '
noremap ' `
noremap ` '

" Reformat code according to linux kernel (my favourite)
nmap <F2> :!formatc %<CR>L<CR>
""" }}}
""" {{{ Spellcheck
nmap <Leader>ss :set nospell<CR>
nmap <Leader>se :set spell spelllang=en<CR>
nmap <Leader>sn :set spell spelllang=nl<CR>
""" }}}
""" {{{ Quickfix window
nmap <silent> <Leader>vp :call Pep8()<CR>
nmap <silent> <Leader>vc :cclose<CR>
nmap <silent> <Leader>vn :cnext<CR>
nmap <silent> <Leader>vN :cprev<CR>
""" }}}
""" {{{ Remove inconvenient binds
xmap K k
nmap Q <Nop>
""" }}}
"" }}}
"" {{{ Plugin bindings
""" {{{ Bisect
nmap ↓ <Plug>BisectDown
nmap ↑ <Plug>BisectUp
nmap ← <Plug>BisectLeft
nmap → <Plug>BisectRight
nmap Æ <Plug>StopBisect

xmap ↓ <Plug>VisualBisectDown
xmap ↑ <Plug>VisualBisectUp
xmap ← <Plug>VisualBisectLeft
xmap → <Plug>VisualBisectRight
xmap Æ <Plug>VisualStopBisect
""" }}}
""" {{{ Command-T
nmap <silent> <Leader>T :CommandTFlush<CR>
""" }}}
""" {{{ Lusty Explorer
nmap <silent> <Leader>n :LustyBufferExplorer<CR>
nmap <silent> <Leader>G :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>r :LustyFilesystemExplorerFromHere<CR>
""" }}}
""" {{{ Lusty Juggler
nmap <silent> <Leader>j :LustyJuggler<CR>
"""
""" {{{ Taglist
nmap <silent> <Leader>l :TlistOpen<CR>
nmap <silent> <Leader>L :TlistToggle<CR>
""" }}}
""" {{{ NERD Tree
nmap <silent> <Leader>h :call TreeOpenFocus()<CR>
nmap <silent> <Leader>H :NERDTreeToggle<CR>
""" }}}
""" {{{ BClose
nmap <silent> <Leader>d :Bclose<CR>
nmap <silent> <Leader>D :Bclose!<CR>
""" }}}
""" {{{ Operator-Replace
map <Leader>_ <Plug>(operator-replace)
""" }}}
""" {{{ Git extras
nmap <Leader>gL :GitLog HEAD<CR>
nmap <Leader>gC :GitCommit -s -a<CR>
nmap <Leader>gt :GitCommit -s<CR>
nmap <Leader>gS :GitAdd<Space>
nmap <Leader>gb :GitBlame<CR>
nmap <Leader>gP :GitPull origin master<CR>
nmap <Leader>gr :GitPush<CR>
""" }}}
"" }}}
" }}}
"" {{{ Configuration
"" {{{ Plugin configuration
""" {{{ NERD Commenter
let NERDDefaultNesting = 1
""" }}}
""" {{{ NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$', '\.o$', '\.pyo$']
let NERDTreeSortOrder = ['\/$', '\.[ch]$', '\.py$', '*']
""" }}}
""" {{{ Taglist
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Enable_Fold_Column = 0
""" }}}
""" {{{ Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0
if exists('~/.ropevim')
  source ~/.ropevim/rope.vim
  let ropevim_vim_completion=1
  let ropevim_extended_complete=1
endif
""" }}}
""" {{{ Command-T
let g:CommandTMaxHeight = 10
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTScanDotDirectories = 1
""" }}}
""" {{{ snipMate
let g:snips_author = "Lucas de Vries"
let g:snips_mail = "lucas@glacicle.org"
""" }}}
""" {{{ delimitMate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
""" }}}
""" {{{ superTab
let g:SuperTabDefaultCompletionType = "<c-n>"
""" }}}
""" {{{ ZenCoding
let g:user_zen_settings = {'indentation': '  ',}
let g:user_zen_leader_key = '<C-t>'
""" }}}
""" {{{ Don't load ruby
if !has('ruby')
  let g:command_t_loaded = 1
  let g:loaded_lustyexplorer = 1
  let g:LustyJugglerSuppressRubyWarning = 1
else
  let g:LustyJugglerShowKeys = 'a'
endif
""" }}}
""" {{{ ctab settings
let g:ctab_filetype_maps = 1
""" }}}
"" }}}
"" {{{ Vim settings
""" {{{ General
" Memory settings
set maxmempattern=2000000

" Use UTF-8 encoding
set encoding=utf-8

" Allow hidden buffers with changes
set hidden

" Allow backup of files
set backup
set writebackup

" Put swapfiles in central directory
set backupdir=~/tmp,/var/tmp
set directory=~/tmp,/var/tmp

" Data to store in the viminfo file
set viminfo='100,f1,<50,:50,/50,h,!

" File patterns to ignore in completions
set wildignore=*.o,*.pyc,*.pyo,.git,.svn

" Enable mouse for convenient laptop scrolling
set mouse=av

set runtimepath+=/usr/share/lilypond/2.12.3/vim/ 

" Don't use filetype indent
filetype on
filetype plugin on
filetype indent off

" Completeion
set complete=.,w,b,u,t

""" }}}
""" {{{ Display
" Characters to use in list mode
"set listchars=tab:│\ ,trail:·
"set list

" Always display statusline
set laststatus=2

" More informative of the indent style
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat},              " file format
set statusline+=%{CodingStyleIndent()}]      " formatting
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" Show chain while typing
set showcmd

" Show search match while typing
set incsearch

" Show line and column number
set number
set ruler

" Show matching brackets when typed
set showmatch

" Number of lines from the edge to scroll
set scrolloff=3

" Display shorter messages
set shortmess=aAtI

" Don't show so many completions
set pumheight=8

" Highlight matches on a search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" Disable folding...
set nofoldenable

" Highlight syntax
syntax on
set synmaxcol=256
""" }}}
""" {{{ Editing
" Text width
let g:textwidth=0
set textwidth=0

" Use actual block mode for visual block
set virtualedit=block

" Global match by default
set gdefault

" Smart case insensitive search
set ignorecase
set smartcase
""" }}}
""" {{{ Formatting
" Enter spaces when tab is pressed:
" set expandtab

" Use 8 spaces to represent a tab
set tabstop=8
set softtabstop=8

" Number of spaces to use for auto indent
set shiftwidth=8

" Copy indent from current line when starting a new line
set autoindent

" Don't go mad reindenting
"set cinkeys="0{,0},0)"
"set cinoptions=(0,u0,U0

" Allow backspacing over more items
set backspace=indent,eol,start

" Options for formatting blocks (gq)
"set formatoptions=tcn12
""" }}}
""" {{{ Colors
" Color Schemes
set background=dark
if has('gui_running')
    colorscheme herald
else
    colorscheme herald
endif
if has('macunix')
  set guifont=Menlo\ 6
else
  set guifont=Dejavu\ Sans\ Mono\ 6
endif
""" }}}
"" }}}
" }}}
" {{{ Autocommands
"" {{{ Filetype filters
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
"" }}}
"" {{{ Filetype detection
autocmd BufReadPre Cakefile silent set filetype=yaml
autocmd BufNewFile,BufRead *.{md,mkd,mark,markdown} set ft=markdown
autocmd BufNewFile,BufRead *.tex set ft=tex
autocmd BufNewFile,BufRead *.go set ft=go
autocmd BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit
autocmd BufNewFile,BufRead *.als set ft=alloy4
"" }}}
"" {{{ Filetype settings
" Files to indent with two spaces
autocmd FileType xhtml,html,xml,sass,tex,plaintex,yaml,lilypond,vim silent setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

" Files to indent with four spaces
autocmd FileType python silent setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4

" Set correct folding for C
autocmd FileType c,h,cpp silent setlocal fdm=syntax fdn=1
autocmd FileType c,h,cpp set cindent

" Git: Don't jump to last position, no modeline
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
autocmd FileType git setlocal nomodeline

" Files to set default textwidth
autocmd FileType mail,tex set textwidth=78
autocmd FileType mail,tex let g:textwidth=78

" Files to use filetype indent on
autocmd BufReadPre *.lua filetype indent on

"" }}}
"" {{{ Filetype highlighting
" Python keywords
autocmd FileType python syn keyword Identifier self
autocmd FileType python syn keyword Type True False None

" Javascript let is a keyword
autocmd FileType javascript syn keyword javascriptIdentifier "let"

" TeX zone
autocmd FileType tex,plaintex hi link TexZone Comment

" Mail header highlighting
autocmd FileType mail hi link mailHeader Comment
autocmd FileType mail hi link mailSubject Function
"" }}}
"" {{{ Other
" Jump to last known cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

" Rainbow Parenthesis
autocmd BufReadPost *
\ call rainbow_parenthesis#LoadBraces() |
\ call rainbow_parenthesis#LoadSquare() |
\ call rainbow_parenthesis#LoadRound() |
\ call rainbow_parenthesis#Activate()

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=#34343C ctermbg=233
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#48484F ctermbg=234

" Set tags
set tags=./.tags;

" Conque
let g:ConqueTerm_Color = 2
"let g:ConqueTerm_SessionSupport = 0
"let g:ConqueTerm_ReadUnfocused = 1
"let g:ConqueTerm_InsertOnEnter = 0
"let g:ConqueTerm_CloseOnEnd = 0
"let g:ConqueTerm_StartMessages = 0
"let g:ConqueTerm_Syntax = 'conque'
"let g:ConqueTerm_EscKey = '<Esc>'
"let g:ConqueTerm_ToggleKey = '<F8>'
"let g:ConqueTerm_CWInsert = 0
"let g:ConqueTerm_ExecFileKey = '<F11>'
"let g:ConqueTerm_SendFileKey = '<F10>'
"let g:ConqueTerm_SendVisKey = '<F9>'
"let g:ConqueTerm_SendFunctionKeys = 0
"let g:ConqueTerm_TERM = 'xterm'

"" }}}
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
" }}}
" {{{ NuToggle(): Toggle between abs/rel nu
let g:nu = 0
function! NuToggle()
    if g:nu == 0
        let g:nu = 1
        set rnu
    else
        let g:nu = 0
        set nu
    endif
endfunction
" }}}
"" {{{ TreeOpenFocus(): Open the nerd tree or focus it.
function! TreeOpenFocus()
    let wnr = bufwinnr("NERD_tree_1")
    if wnr == -1
        :NERDTreeToggle
    else
        exec wnr."wincmd w"
    endif
endfunction
"" }}}
" {{{ PromptFT(): Prompt for a new filetype to set
function! PromptFT(show)
    let def = ""

    if a:show == 1
        let def = &ft
    endif

    let ft = input("Filetype: ", def)
    if ft != ""
        exec "setlocal ft=".ft
        Rainbow
    end
endfunction
" }}}
" }}}

" vim:fdm=marker
