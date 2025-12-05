#!/bin/bash
exit 0
# ----------------------------------------------------------

## 參照 kustomization.yaml 合併裡頭的 resources, 並補上 commonLabels 區塊, 最後印出
kustomize build .

## 如上, 最後套用
kustomize build . | kubectl apply -f -
kustomize build . | kubectl delete -f -


##