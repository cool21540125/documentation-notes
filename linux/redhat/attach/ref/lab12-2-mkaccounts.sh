#!/bin/bash

cmdOption=$1
case $cmdOption in
 '')
  ;;
 -v)
  VERBOSE=y
  ;;
 -h)
  echo "Usage: $0 [-h|-v]"
  echo
  exit
  ;;
 *)
  echo "Usage: $0 [-h|-v]"
  echo
  exit 1
  ;;
esac

newUserfile=/root/newusers

for userEntry in $(cat $newUserfile); do
 firstName=$(echo $userEntry | cut -d: -f1)
 lastName=$(echo $userEntry | cut -d: -f2)
 userTier=$(echo $userEntry | cut -d: -f4)
 
 fN=$(echo $firstName | cut -c 1 | tr 'A-Z' 'a-z')
 lN=$(echo $lastName | tr 'A-Z' 'a-z')
 userAccount=$fN$lN

 #test conflicts
 acctExist=''
 acctExistname=''

 id $userAccount &> /dev/null
 if [ $? -eq 0 ] ; then
  acctExist=y
  acctExistname=$(grep '^$userAccount:' /etc/passwd | cut -f5 -d:)
 fi
 
 #add account
 if [ "$acctExist" = 'y' ] && [ "$acctExistname" = "$fN $lN" ] ; then
  echo "Skipping $userAccount. Duplicate found."
 elif [ "$acctExist" = 'y' ] ; then
  echo "Skipping $userAccount. Conflict found."
 else
  useradd -c "$firstName $lastName" $userAccount
  if [ "$VERBOSE" = 'y' ] ; then
   echo "Added $userAccount."
  fi
 fi
done

totalUsers=$(cat $newUserfile | wc -l)
for i in $(seq 1 3) ; do
 printString="\"Tier ${i}\","
 printString="$printString\"$(grep -c ":${i}$" $newUserfile)\","
 printString="$printString\"$[ $(grep -c ":${i}$" $newUserfile) * 100 / $totalUsers ]%\""
 echo $printString
done
