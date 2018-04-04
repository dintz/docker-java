# Func to gen PS1 after CMDs
PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local EXIT="$?"  # This needs to be first
    PS1=""

    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'

    if [ $EXIT != 0 ]; then
        P_EXIT="${Red}${EXIT}${RCol}"
    else
        P_EXIT="${Gre}${EXIT}${RCol}"
    fi

    PS1="
\[\e[31;1m\]┌───=[ \[\e[39;1m\]\u\[\e[31;1m\] :: \[\e[33;1m\]\h\[\e[31;1m\] ]-( \[\e[39;1m\]${P_EXIT}\[\e[31;1m\] )-[ \[\e[39;1m\]\w\[\e[31;1m\] ]
\[\e[31;1m\]└───○ \[\e[0m\]"
}

# Display running command in GNU Screen window status
#
# In .screenrc, set: shelltitle "( |~"
#
# See: http://aperiodic.net/screen/title_examples#setting_the_title_to_the_name_of_the_running_program
case $TERM in screen*)
  PS1=${PS1}'\[\033k\033\\\]'
esac

# set different aliases
alias ls="ls --color=always"
alias l="ls -lh"
alias ll="ls -lAh"
alias la="ls -lah"
alias hg='history | grep '
alias findy='find . -name'
