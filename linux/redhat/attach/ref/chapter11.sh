#!/bin/bash
# Displaying output
echo "[Displaying output example]"
echo "Hello, world."

echo "Error: Houston, we have a problem." >&2
echo "==================="
echo ""

# Command substitution
echo "[Command substitution example]"
TarOutput=$(tar cvf /root/incremental_backup.tar $(find /etc -type f -mtime -1))
echo "BackupFile: "
echo $TarOutput
echo "==================="
TarOutput=$(find /etc -type f -mtime -1)
tar cvf /root/incremental_backup.tar $TarOutput &> /dev/null
echo "BackupFile: "
echo $TarOutput
echo "==================="
echo ""

# Arithmetic expansion
echo "[Arithmetic expansion example]"
echo '1+1=' $[1+1]
echo '2*2=' $[2*2]
Count=1
echo 'Count=1'
echo '(Count+1)*2=' $[ $[ $Count + 1 ] * 2 ]
echo "==================="

var=1
echo 'var=' $var
echo 'Before var++: var=' $[ var++ ]
echo 'After  var++: var=' $var

echo 'var=' $var
echo 'Before ++var: var=' $[ ++var ]
echo 'After  ++var: var=' $var

echo 'var=' $var
echo 'Before var--: var=' $[ var-- ]
echo 'After  var--: var=' $var

echo 'var=' $var
echo 'Before --var: var=' $[ --var ]
echo 'After  --var: var=' $var
echo "==================="
echo ""

# for loop
echo "[for loop example]"
for Package in $(rpm -qa | grep kernel) ; do
 echo -n "$Package was install on "
 echo $(date -d @$(rpm -q --qf "%{INSTALLTIME}\n" $Package))
done
echo "==================="

for i in $(seq 1 2 10) ; do
 echo $i
done
echo "Who do we appreciate"
echo "==================="
echo ""
