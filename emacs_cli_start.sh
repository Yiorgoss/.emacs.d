#!/bin/bash
BG_RED=`tput setaf 1`
BG_GREEN=`tput setaf 2`
BOLD=`tput bold`
RESET=`tput sgr0`

EMACS='/Applications/Emacs.app'
EMACS_CLIENT='/usr/local/bin/emacsclient'

DEFAULT_EVAL='(switch-to-buffer "*scratch*")'
DEFAULT_ARGS="-e"
NO_WAIT='-n'

function run_client(){
    if [ $# -ne 0 ]
    then
        ${EMACS_CLIENT} ${NO_WAIT} $@
    else
        ${EMACS_CLIENT} ${NO_WAIT} ${DEFAULT_ARGS} "${DEFAULT_EVAL}" &> /dev/null
    fi
}

echo -e "Checking Emacs server status...\c"
if pgrep Emacs &> /dev/null
then
    echo "${BOLD}${BG_GREEN}Active${RESET}"
    echo -e "Connecting...\c"
    run_client $*
    echo "${BOLD}${BG_GREEN}DONE${RESET}"
else
    echo "${BOLD}${BG_RED}Inactive${RESET}"
    echo -e "Emacs server is starting...\c"
    open -a ${EMACS}
    echo "${BOLD}${BG_GREEN}DONE${RESET}"

    echo -e "Trying connecting...\c"
    until run_client $* &> /dev/null;[ $? -eq 0 ]
    do
        sleep 1
    done
    echo "${BOLD}${BG_GREEN}DONE${RESET}"
fi
