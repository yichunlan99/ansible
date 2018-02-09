if [ $UID -eq 0 ];then
    export PS1="[\[\e[32;40m\]\u\[\e[0m\]@\h\[\e[31;40m\]-PROD-\[\e[0m\]\W]\\$ "
else
    export PS1="[\u@\h\[\e[31;40m\]-PROD--\[\e[0m\]\W]\\$ "
fi
