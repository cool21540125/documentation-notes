#!/bin/bash


### Start
minikube addons enable ingress

kubectl create namespace demo

kubectl create deployment demo \
    --image=httpd \
    --port=80 \
    --namespace=demo

kubectl expose deployment \
    --namespace=demo \
    demo

kubectl create ingress demo-localhost \
    --namespace=demo \
    --class=nginx \
    --rule="demo.localdev.me/*=demo:80"

kubectl port-forward \
    --namespace=ingress-nginx \
    service/ingress-nginx-controller 8080:80

# GOTO http://demo.localdev.me:8080/


#### Clean up




minikube addons disable ingress