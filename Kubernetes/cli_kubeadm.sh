#!/bin/bash
exit 0
# -----------------------------------------------------------------

###
kubeadm config print init-defaults >init.default.yaml

### show kubeadm images
kubeadm config images list
#registry.k8s.io/kube-apiserver:v1.33.0
#registry.k8s.io/kube-controller-manager:v1.33.0
#registry.k8s.io/kube-scheduler:v1.33.0
#registry.k8s.io/kube-proxy:v1.33.0
#registry.k8s.io/coredns/coredns:v1.12.0
#registry.k8s.io/pause:3.10
#registry.k8s.io/etcd:3.5.21-0
