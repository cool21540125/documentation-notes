### 使用者 command 記錄到 /var/log/cmd.log

### 舊版
export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'
echo -e "\nexport PROMPT_COMMAND='RETRN_VAL="'$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'"'" >> /etc/bashrc

### 新版
export LOGIN_TTY=$(tty |sed 's@/dev/@@g')
export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$(w -i |grep $LOGIN_TTY |awk '"'{print\$3}'"')] [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'
echo -e "\nexport LOGIN_TTY="'$(tty |sed '"'s@/dev/@@g')" >> /etc/bashrc
echo -e "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local6.debug "'"$(whoami) [$(w -i |grep $LOGIN_TTY |awk '"'"'"'"'{print\\\$3}'"'"'"'"')] [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'"'" >> /etc/bashrc

sed -i -e '/local7/a\\n# ALL user command to cmd.log' /etc/rsyslog.conf
sed -i -e '/# ALL user command to cmd.log/alocal6.debug /var/log/cmd.log' /etc/rsyslog.conf
systemctl restart rsyslog