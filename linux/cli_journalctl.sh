#!/bin/bash
exit 0
# ----------------------------------------------------------

###
journalctl -u mysqld >/tmp/mysql_init_log

journalctl -u journald
