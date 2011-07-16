"
" Tai Chi Minh Ralph Eastwood's .vimrc
" Nick: Raedwulf
" Mail: tcmreastwood@gmail.com
"

" Enable pathogen.
call pathogen#infect()

" Enable solarized theme.
syntax enable
if has('gui_running')
    set background=light
else
    set background=dark
endif
let g:solarized_termcolors=256
colorscheme solarized

" Set hidden
set hidden
