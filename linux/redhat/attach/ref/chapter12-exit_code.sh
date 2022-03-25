#!/bin/bash
echo ""
ls /etc/hosts
echo -e "File exists:\t\texit_code is" $?
ls /etc/aaabbbccc &> /dev/null
echo -e "Oh, no file exists:\texit_code is" $?
echo "=========================================="

grep localhost /etc/hosts &> /dev/null
echo -e "Catch something:\texit_code is" $?
grep aaabbbccc /etc/hosts &> /dev/null
echo -e "Catch nothing:\t\texit_code is" $?

echo "=========================================="
exit 66
