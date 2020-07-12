# k8s-fun

### Description
A place to test out various k8s things deployed with flux.

### Things currently setup:
  - fluxcloud(slack notifications)
  - sealed-secrets
  - traefik

### Not yet working
  - metallb

### Access traefik dashboard
```
kubectl -n ingress port-forward deployment/traefik 9000:9000
http://127.0.0.1:9000/dashboard/#/
```
