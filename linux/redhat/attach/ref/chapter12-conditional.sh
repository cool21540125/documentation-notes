#!/bin/bash
echo ""
echo '[Example 1: if/then]'
systemctl is-active psacct &> /dev/null
if [ $? -ne 0 ] ; then
 systemctl status psacct | head -n 3
fi

echo ""
echo '[Example 2: if/then/else]'
systemctl is-active psacct &> /dev/null
if [ $? -ne 0 ] ; then
 systemctl status psacct | head -n 3
else
 systemctl stop psacct
 systemctl status psacct
fi

echo ""
echo '[Example 3: if/then/elif/then/else]'
systemctl is-active mariadb &> /dev/null
mariadb_Active=$?
systemctl is-active postgresql &> /dev/null
postgresql_Active=$?

if [ "$mariadb_Active" -eq 0 ] ; then
 echo "Run the mariadb client:"
 mysql
elif [ "$postgresql_Active" -eq 0 ] ; then
 echo "Run the postgresql client:"
 psql
else
 echo "Run the sqlite3 client:"
 sqlite3
fi

echo ""
echo '[Example 4: case statement]'
echo -n 'The first number is: '
case "$1" in
 1)
 echo "one."
 ;;
 2)
 echo "two."
 ;;
 3)
 echo "three."
 ;;
 *)
 echo "please input a 1-3 number."
 ;;
esac
echo ''
