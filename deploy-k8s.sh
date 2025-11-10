#!/bin/bash

set -e

echo "Deploying DataHub to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed or not in PATH"
    exit 1
fi

# Apply the Kubernetes configuration
kubectl apply -f k8s-datahub.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n datahub --timeout=300s || true
kubectl wait --for=condition=ready pod -l app=elasticsearch -n datahub --timeout=300s || true
kubectl wait --for=condition=ready pod -l app=kafka -n datahub --timeout=300s || true
kubectl wait --for=condition=ready pod -l app=datahub-gms -n datahub --timeout=300s || true
kubectl wait --for=condition=ready pod -l app=datahub-frontend -n datahub --timeout=300s || true

echo ""
echo "DataHub deployed successfully!"
echo ""
echo "To access DataHub:"
echo "  kubectl port-forward -n datahub svc/datahub-frontend 9002:9002"
echo "  Then open: http://localhost:9002"
echo ""
echo "Default credentials:"
echo "  Username: datahub"
echo "  Password: datahub"
echo ""
echo "To check status: kubectl get pods -n datahub"
echo "To view logs: kubectl logs -n datahub -l app=datahub-frontend"
