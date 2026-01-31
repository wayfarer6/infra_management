```bash
kubectl create secret generic my-database-secret \
  --from-literal=username=dbuser \
  --from-literal=password=verysecurepassword \
  --dry-run=client -o yaml > secret.yaml
```
# dry-run=client : 실제 리소스 생성 x , yaml로 출력
# data에 들어간 값은 Base64 인코딩된 문자열
```bash
kubeseal < secret.yaml > sealed-secret.yaml
```


```bash
kubectl create secret generic dev-ops-secret \
  --from-literal=jenkins-admin=MyJenkinsPW \
  --from-literal=code-server-password=MyCodeServerPW \
  --dry-run=client -o yaml > secret.yaml

```bash
kubeseal < secret.yaml > sealed-secret.yaml
```