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
if !exists('g:indenthlstyle') | let g:indenthlstyle = 1 | endif

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
function IndentHL()
  if (g:indenthlinfertabmode)
    if (&et)
      exec 'syn match cTab1 /^ \{'. &sw .'}/'
      for i in range(2,g:indenthlmaxdepth)
        exec 'syn match cTab'. i .' /\(^ \{'. &sw*(i-1) .'}\)\@<= \{'. &sw .'}/'
      endfor
      syn match cTabError /^\t\+/
    else
      syn match cTab1 /^[\t]/
      for i in range(2,g:indenthlmaxdepth)
        exec 'syn match cTab'. i .' /\(^\t\{'. (i-1) .'}\)\@<=\t */'
      endfor
      syn match cTabError /^ \+/
    endif
  else
    syn match cTab1 /^[\t]/
    for i in range(2,g:indenthlmaxdepth)
      exec 'syn match cTab'. i .' /\(^ \{'. (i-1) .'}\)\@<=\t */'
    endfor
  endif

  syn match cTabError /^ \+\t\+/
  syn match cTabError /^\t\+ \+$/
  syn match cTabError /^\t\+ \+\t\+/

  " examples of all combinations of spaces and tabs (for debugging):
      
     
      
     
      
      

  command! -nargs=+ HiLink hi def <args>

  for i in range(1,g:indenthlmaxdepth)
    exec 'HiLink cTab'. i .' ctermbg='. (232+i) .' guibg=gray'. (20+(i-1)*5)
  endfor

  " Error highlighting:
  if (g:indenthlshowerrors)
    HiLink cTabError ctermbg=Red guibg=Red
  endif

  delcommand HiLink
endfunction

autocmd BufReadPost * call IndentHL()
"}}}
" vim: set fdm=marker:et:sw=2:ts=2:sts=2:
