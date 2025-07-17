#!/bin/bash

# Deploy PostgreSQL first
echo "Deploying PostgreSQL..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install postgresql bitnami/postgresql \
  --namespace n8n \
  --create-namespace \
  --values values-postgresql.yaml \
  --wait

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql --timeout=300s -n n8n

# Deploy n8n
echo "Deploying n8n..."
helm install n8n ./n8n-chart \
  --namespace n8n \
  --values values.yaml \
  --wait

echo "Deployment completed!"
echo "PostgreSQL Service: postgresql-primary.n8n.svc.cluster.local:5432"
echo "n8n should be available once the deployment is complete"
