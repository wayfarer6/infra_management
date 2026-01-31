
# Check helm syntax 

```bash
helm template dev-ops .
```

# install chart

```bash
kubectl create namespace devops
helm install dev-ops . -n devops
kubectl get all -n devops
kubectl get pods -n devops
kubectl get ingress -n devops
```