#!/bin/bash
exit 0
# -----------------------------------------------------------------------------------------------------------------------

### ========================================== CA ==========================================
export CA_DOMAIN=ca.weibyapps.dev
export CA_SUBJ="/C=TW/ST=Taiwan/L=Taichung/O=SelfCA/OU=DevOps/CN=${CA_DOMAIN}"
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 36500 -out ca.crt -subj ${CA_SUBJ}

### ========================================== Admin Certs ==========================================
export MASTER_DOMAIN=k8s-admin.weibyapps.dev
export MASTER_SUBJ="/CN=admin/O=system:masters"
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -subj ${MASTER_SUBJ} -out _admin.csr
openssl x509 -req -in _admin.csr -CA ca.crt -CAkey ca.key -out admin.crt
#Certificate request self-signature ok
#subject=CN = admin, O = system:masters

### ========================================== Kube Controller-Manager Certs ==========================================
export CONTROLLER_SUBJ="/CN=system:kube-controller-manager"
openssl genrsa -out kube-controller.key 2048
openssl req -new -key kube-controller.key -subj ${CONTROLLER_SUBJ} -out _kube-controller.csr
openssl x509 -req -in _kube-controller.csr -CA ca.crt -CAkey ca.key -out kube-controller.crt
#Certificate request self-signature ok
#subject=CN = system:kube-controller-manager

### ========================================== Kube Proxy Client Certs ==========================================
export KUBE_PROXY_SUBJ="/CN=system:kube-proxy"
openssl genrsa -out kube-proxy.key 2048
openssl req -new -key kube-proxy.key -subj ${KUBE_PROXY_SUBJ} -out _kube-proxy.csr
openssl x509 -req -in _kube-proxy.csr -CA ca.crt -CAkey ca.key -out kube-proxy.crt
#Certificate request self-signature ok
#subject=CN = system:kube-proxy

### ========================================== Kube Scheduler Certs ==========================================
export KUBE_SCHEDULER_SUBJ="/CN=system:kube-scheduler"
openssl genrsa -out kube-scheduler.key 2048
openssl req -new -key kube-scheduler.key -subj ${KUBE_SCHEDULER_SUBJ} -out _kube-scheduler.csr
openssl x509 -req -in _kube-scheduler.csr -CA ca.crt -CAkey ca.key -out kube-scheduler.crt
#Certificate request self-signature ok
#subject=CN = system:kube-scheduler

### ========================================== Kube Api Server Certs ==========================================
export KUBE_API_SERVER_SUBJ="/CN=system:kube-scheduler"
