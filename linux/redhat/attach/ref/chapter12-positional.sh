#!/bin/bash
echo ""
echo '[This is positional parameters example]'
echo "Variables number is $#."
echo "========================="

echo "The command is:" $0
echo "The first parameter is:" $1
echo "The second parameter is:" $2
echo "The third parameter is:" $3
echo "The fourth parameter is:" $4
echo "The fifth parameter is:" $5
echo "========================="
echo "All parameters are seen as a single word:"
for i in "$*" ; do
 echo $i
done
echo ""
echo "All parameters are seen as a separate word:"
for i in "$@" ; do
 echo $i
done
echo "========================="
echo ""
echo "[User input]"
read -p "Please input a word: " i
echo $i
echo ""
