#!/bin/bash
newUserfile=/root/newusers

for userEntry in $(cat $newUserfile); do
 firstName=$(echo $userEntry | cut -d: -f1)
 lastName=$(echo $userEntry | cut -d: -f2)
 userTier=$(echo $userEntry | cut -d: -f4)
 
 fN=$(echo $firstName | cut -c 1 | tr 'A-Z' 'a-z')
 lN=$(echo $lastName | tr 'A-Z' 'a-z')
 userAccount=$fN$lN
 
 useradd -c "$firstName $lastName" $userAccount
done

totalUsers=$(cat $newUserfile | wc -l)
for i in $(seq 1 3) ; do
 printString="\"Tier ${i}\","
 printString="$printString\"$(grep -c ":${i}$" $newUserfile)\","
 printString="$printString\"$[ $(grep -c ":${i}$" $newUserfile) * 100 / $totalUsers ]%\""
 echo $printString
done
