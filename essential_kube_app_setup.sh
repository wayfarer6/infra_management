#!/bin/bash

export root_domain="example.com"

# Update system packages
sudo dnf update -y

# Install Argo Cd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Use Traefik as the ingress controller for Argo CD

kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
    name: argocd-cm
    namespace: argocd
data:
    url: https://argo-cd.${root_domain}
    dex.config: |
        connectors:
        - type: oidc
            name: Google
            config:
            clientID: your-client-id
            clientSecret: your-client-secret
            redirectURI: https://argo-cd.${root_domain}/api/dex/callback
EOF

# 개인 Gmail 계정을 사용하여 Google의 OpenID Connect 서비스를 무료로 이용할 수 있습니다. 
# 위의 clientID 및 clientSecret 값을 Google Cloud Console에서 OAuth 2.0 클라이언트 ID를 생성하여 얻을 수 있습니다.  feat 제미나이

# Install VictoriaMetrics

# 1. 레포지토리 추가
helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo update

# 2. 설치 (가장 가벼운 'single' 모드로 설치됨)
helm install vmstack vm/victoria-metrics-k8s-stack --namespace monitoring --create-namespace

# 3. 설치 확인
kubectl get pods -n monitoring
echo "Essential Kubernetes applications have been set up."