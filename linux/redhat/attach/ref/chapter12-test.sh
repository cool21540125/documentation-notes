#!/bin/bash
for i in $(seq 3) ; do
 ping -c1 foundation${i} &> /dev/null && \
 echo "Begin remote installation on foundation${i}." || \
 echo 'Keep foundation${i} failed record in text file!'
done
