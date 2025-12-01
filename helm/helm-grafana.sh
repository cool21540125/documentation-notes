#!/bin/bash
exit 0
#
# https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/
#
# ----------------------------------------------

##
helm repo add grafana https://grafana.github.io/helm-charts
helm repo list
helm install my-grafana grafana/grafana --namespace ob --create-namespace

## 取得 HELM 基本摘要
helm get notes my-grafana -n ob

## 取得 admin password
kubectl get secret --namespace ob my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

## 使用 custom values
helm upgrade my-grafana grafana/grafana --namespace ob -f my-helm/grafana-values.yaml
