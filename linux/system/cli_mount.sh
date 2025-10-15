#!/bin/bash
exit 0
# -------------------------------------------------------


### EC2 Linux mount EFS
sudo mkdir /efs
sudo mount -t nfs -o tls $EFS_ID.efs.$REGION.amazonaws.com:/ /efs


### 