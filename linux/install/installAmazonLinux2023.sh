#!/bin/bash
exit 0
# -------------------------

### ================== Install nginx ==================
sudo yum install -y nginx

sudo systemctl start nginx
sudo systemctl enable nginx
systemctl status nginx

### ================== Install golang ==================
sudo dnf install golang

###
