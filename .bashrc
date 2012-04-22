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

PATH=$PATH:/home/raedwulf/bin/RTaW-Sim-1.1.1/bin;export PATH; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - RealTime-At-Work RTaW-Sim 1.1.1.0 7FB03BAE-BB7D-5C27-ADCF-1A00F64EF810

PATH=$PATH:/home/raedwulf/code/current/RTaW-Sim-1.2.7/bin;export PATH; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - RealTime-At-Work RTaW-Sim 1.2.7.0 A6633109-2604-220A-C039-1B5B38D6F81B
