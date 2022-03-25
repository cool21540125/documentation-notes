#!/bin/bash
dbUser=root
fmOptions='--skip-column-names -E'
dbCommand='show databases'
backupDir=/dbbackup

for dbName in $(mysql $fmOptions -u $dbUser -predhat -e "$dbCommand" \
               | grep -v '^*' | grep -v 'schema$') ; do
 echo "Backing up \"$dbName\""
 mysqldump -u $dbUser -predhat $dbName > $backupDir/$dbName.dump
done

echo "=========================="
for dbDump in $backupDir/*; do
 dbSize=$(stat --printf "%s\n" $dbDump)
 totalSize=$((totalSize+dbSize))
done

for dbDump in $backupDir/*; do
 dbSize=$(stat --printf "%s\n" $dbDump)
 echo "$dbDump,$dbSize,$[ 100 * $dbSize / $totalSize ]%" 
done
