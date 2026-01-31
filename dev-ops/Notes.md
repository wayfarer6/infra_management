
# Check helm syntax 

```bash
helm template dev-ops .
```

# install chart


# 먼저 네임 스페이스 만들고 secret 적용하기

```bash
 kubectl create namespace devops # 네임스페이스
 kubectl apply -f SealedSecret.yaml
```


```bash

helm install dev-ops . -n devops
kubectl get all -n devops
kubectl get pods -n devops
kubectl get ingress -n devops
```


#재시작

```bash
kubectl rollout restart deployment code-server-deployment -n devops
```

# 업그레이드 

```bash

helm upgrade --install dev-ops . -n devops
```

# 재생성을 위한 pod 삭제

```bash
kubectl delete pod -n devops --all

kubectl delete deployment --all -n devops #deploymenet 삭제
```

# uninstall

```bash
kubectl delete namespace devops


```