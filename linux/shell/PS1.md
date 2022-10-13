

# I. (淡藍色) 時間 + 所在路徑

![PS1-time+path](./../img/PS1-time-path.png)

```sh
CYAN="\[\e[01;36m\]"
WHITE="\[\e[01;37m\]"
BLUE="\[\e[01;34m\]"
TEXT_RESET="\[\e[00m\]"
TIME="\t"
CURRENT_PATH="\W"
ROOT_OR_NOT="\$"
export PS1="${CYAN}[${BLUE}${TIME}${WHITE} ${CURRENT_PATH}${CYAN}]${ROOT_OR_NOT}${TEXT_RESET} "

```