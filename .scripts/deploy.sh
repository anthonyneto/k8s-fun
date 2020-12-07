#!/bin/bash
kubectl create namespace flux

helm repo add fluxcd https://charts.fluxcd.io

helm upgrade -i flux fluxcd/flux \
  --set git.url="git@github.com:anthonyneto/k8s-fun" \
  --set git.user="flux" \
  --set git.email="flux@github.com" \
  --set git.path="flux" \
  --set additionalArgs="{--connect=ws://fluxcloud}" \
  --set git.ssh.secretName="flux-git-deploy" \
  --set syncGarbageCollection.enabled="true" \
  --namespace flux

kubectl -n flux rollout status deployment/flux -w

kubectl -n flux delete secret flux-git-deploy
kubectl -n flux create secret generic flux-git-deploy --from-file=identity="/home/$(whoami)/.ssh/id_rsa"
kubectl -n flux rollout restart deployment/flux

kubectl -n flux rollout status deployment/flux -w

helm upgrade -i helm-operator fluxcd/helm-operator \
  --set git.ssh.secretName=flux-git-deploy \
  --set helm.versions=v3 \
  --namespace flux

kubectl -n flux rollout status deployment/helm-operator -w
