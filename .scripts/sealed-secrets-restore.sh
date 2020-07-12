#!/bin/bash
NAMESPACE='sealed-secrets-controller'

mkdir -p .tmp

kubectl create namespace $NAMESPACE
kubectl apply -f .tmp/master.key
kubectl delete pod -n $NAMESPACE -l app.kubernetes.io/instance=sealed-secrets-controller
