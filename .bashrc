# Applications
export PAGER='vimpager'
export EDITOR='vim'
export VISUAL='vim'
export SVN_EDITOR=$EDITOR
export BROWSER='chromium'

# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
