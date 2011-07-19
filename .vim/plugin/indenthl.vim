" indenthl.vim: highlights each indent level in different colors.

" Author: Dane Summers
" Date: March 23, 2011
"
" See :help mysyntaxfile-add for how to install this file.

" Options"{{{

" When SET: will infer what is 'error' highlighting and what isn't:
"    When the expandtab option is set: NO TABS should be at the beginning of
"    the line. Any lines with tabs in the beginning whitespace will be highlighted
"    as cTabError
"    When the expandtab is not set: TABS are expected at the beginning of the 
"    line. Any lines beginning with non-TAB whitespace will be highlighted
"    as cTabError.
" When NOT SET: highlighting will just highlight TABs as indents (original
" behavior of this plugin).
if !exists('g:indenthlinfertabmode') | let g:indenthlinfertabmode = 0 | endif

" When SET: Will highlight any combinations of tabs and spacing at the beginning
" of the line as cTabError (defualt RED)
if !exists('g:indenthlshowerrors') | let g:indenthlshowerrors = 0 | endif

" Style of highlighting. Three styles:
" 1: to make colors slightly darker at each level (in gui)
" 2: all alternating colors:
" 3: all alternating colors, but it gets darker with each alternate:
if !exists('g:indenthlstyle') | let g:indenthlstyle = 3 | endif

" Maximum depth of highlighting
if !exists('g:indenthlmaxdepth') | let g:indenthlmaxdepth = 12 | endif

" TODO: Background colour for indenthl to fit with colour schemes more nicely

"}}}
" highlightings"{{{
"
" This style matching would be more efficient, but apparently the \zs can't
" look into regions matched by other patterns (in this example the cTab1 match
" prevents the \zs from matching starting at the second tab):
" syn match cTab2 /^\t\zs\t/
"
if (g:indenthlinfertabmode)
  if (&et)
    exec 'syn match cTab1 /^ \{'. &sw .'}/'
    for i in range(2,g:indenthlmaxdepth)
      exec 'syn match cTab'. i .' /\(^ \{'. &sw*(i-1) .'}\)\@<= \{'. &sw .'}/'
    endfor
    syn match cTabError /^\t\+/
  else
    syn match cTab1 /^[\t]/
    syn match cTab2 /\(^\t\)\@<=\t/
    for i in range(2,g:indenthlmaxdepth)
      exec 'syn match cTab'. i .' /\(^ \{'. i .'}\)\@<=\t/'
    endfor
    syn match cTabError /^ \+/
  endif
else
  syn match cTab1 /^[\t]/
  syn match cTab2 /\(^\t\)\@<=\t/
  for i in range(2,g:indenthlmaxdepth)
    exec 'syn match cTab'. i .' /\(^ \{'. i .'}\)\@<=\t/'
  endfor
endif

syn match cTabError /^ \+\t\+/
syn match cTabError /^\t\+ \+/

" examples of all combinations of spaces and tabs (for debugging):
		
   
  	
 	 
	  
	 	

command! -nargs=+ HiLink hi def <args>

" Pick one of three options (see
" http://viming.blogspot.com/2007/02/indent-level-highlighting.html for
" screenshots of the three options):

if (g:indenthlstyle == 1)
  " ONE: to make colors slightly darker at each level (in gui)
  for i in range(1,g:indenthlmaxdepth)
    exec 'HiLink cTab'. i .' term=NONE cterm=NONE ctermbg='. (232+i) .'gui=NONE guibg=gray'. (90-(i-1)*5)
  endfor
elseif (g:indenthlstyle == 2)
  " TWO: all alternating colors:
  HiLink cTab1 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
  HiLink cTab2 term=NONE cterm=NONE ctermbg=lightgray gui=NONE guibg=gray95
  HiLink cTab3 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
  HiLink cTab4 term=NONE cterm=NONE ctermbg=lightgray gui=NONE guibg=gray95
  HiLink cTab5 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
  HiLink cTab6 term=NONE cterm=NONE ctermbg=lightgray gui=NONE guibg=gray95
  HiLink cTab7 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
elseif (g:indenthlstyle == 3)
  " THREE: all alternating colors, but it gets darker with each alternate:
  HiLink cTab1 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
  HiLink cTab2 term=NONE cterm=NONE ctermbg=lightgray gui=NONE guibg=gray95
  HiLink cTab3 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
  HiLink cTab4 term=NONE cterm=NONE ctermbg=brown gui=NONE guibg=gray85
  HiLink cTab5 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
  HiLink cTab6 term=NONE cterm=NONE ctermbg=blue gui=NONE guibg=gray75
  HiLink cTab7 term=NONE cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
else
  echoe "indenthl: No such syntax style '". g:indenthlstyle ."' - use 1,2, or 3"
endif

" Error highlighting:
if (g:indenthlshowerrors)
  HiLink cTabError term=NONE cterm=NONE ctermbg=Red gui=NONE guibg=Red
endif

delcommand HiLink
"}}}
" vim: set fdm=marker:et:sw=2:ts=2:sts=2:
