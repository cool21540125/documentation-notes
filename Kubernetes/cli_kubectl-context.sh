#!/bin/bash
exit 0
# ---------------------------------------------------------------------------------------------------------

### 顯示目前有哪些 context
kubectl config get-contexts
#CURRENT   NAME                  CLUSTER               AUTHINFO   NAMESPACE
#          str                   str                   str
#          str-demo-k8s-str-02   str-demo-k8s-str-02   str
#          str-demo-k8s-str-03   str-demo-k8s-str-03   str
#          str-demo-k8s-str01    str-demo-k8s-str01    str
#*         docker-desktop        docker-desktop        docker-desktop

###
kubectl config set-context CONTEXT_NAME --namespace=CONTEXT_NS
kubectl config use-context CONTEXT_NAME

###
