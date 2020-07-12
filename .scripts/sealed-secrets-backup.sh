#!/bin/bash
NAMESPACE='sealed-secrets'

mkdir -p .tmp

kubectl get secret -n $NAMESPACE -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > .tmp/master.key
