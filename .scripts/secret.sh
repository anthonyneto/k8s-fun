#!/bin/bash

read -p "Name: " NAME
read -p "Namespace: " NAMESPACE
read -p "Key: " KEY
read -p "Value: " VALUE

cat <<- EOF
kubectl -n $NAMESPACE create secret generic $NAME  \\
  --dry-run=client \\
  --from-literal=$KEY="$VALUE" \\
  -o yaml | \\
  kubeseal \\
    --controller-namespace sealed-secrets-controller \\
EOF
