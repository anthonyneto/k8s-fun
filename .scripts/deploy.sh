#!/bin/bash
minikube start
sudo chown -R $USER $HOME/.kube $HOME/.minikube;
kubectx minikube

kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller-cluster-rule \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --upgrade --wait --service-account tiller

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
  --set createCRD="true" \
  --set git.ssh.secretName=flux-git-deploy \
  --namespace flux

kubectl -n flux rollout status deployment/helm-operator -w
