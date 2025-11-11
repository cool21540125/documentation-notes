#!/bin/bash
exit 0
# ----------------------------------------------------------------------


eksctl version
#0.214.0


###
eksctl create cluster --name eksctl-cluster --version 1.34 --fargate
eksctl create cluster --name eksctl-cluster --version 1.34 --nodegroup-name linux-nodes --node-type t4g.medium --nodes 2

### 