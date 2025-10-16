#!/bin/bash
exit 0
# 
# --------------------------------------------------------

### 
stress --version
#stress 1.0.7


### Usage
stress -c 4
# 讓 4 個 CPU 飆到 100%


### 配置 250M
stress --vm 1 --vm-bytes 250M --vm-hang 1


### 