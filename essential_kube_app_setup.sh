#!/bin/bash

export root_domain="shseo0308.duckdns.org"

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

# Monitoring stack Access

# 포트포워딩
# kubectl port-forward deployment/vmstack-grafana 13400:3000 -n monitoring

# id 는 admin 이라고 함 , 비번은 별도로 아래 명령어로 

# kubectl get secret --namespace monitoring vmstack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


## cert-manager 설치
helm repo add jetstack https://charts.jetstack.io --force-update

helm repo update

helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.19.2 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true


### 실행전에 cluster issuer 및 wildcard certificate yaml 파일의 root_domain 값을 본인의 도메인으로 변경할 것

#duck dns의 경우 api 키 시크릿에 넣어야 
kubectl create secret generic duckdns-api-token-secret \
  --from-literal=token=<YOUR_DUCKDNS_TOKEN> \
  -n cert-manager

#⚠️ DuckDNS는 기본적으로 cert-manager에 내장된 solver가 없어서, DuckDNS webhook (github.com in Bing) 같은 추가 컴포넌트를 설치!


#DuckDNS webhook 프로젝트 설치

kubectl apply -f https://raw.githubusercontent.com/ebrianne/cert-manager-webhook-duckdns/master/deploy/manifests.yaml
# DuckDNS webhook이 cert-manager와 통신할 수 있도록 권한 부여

#kubectl create secret generic duckdns-api-token-secret \
#  --from-literal=token=<YOUR_DUCKDNS_TOKEN> \
#  -n cert-manager




# ClusterIssuer 및 Wildcard Certificate 생성

# 위에서 secret 생성 후에 아래 명령어 실행
kubectl apply -f ./cert-manager/cluster-issuer.yaml # ClusterIssuer 생성
kubectl apply -f ./cert-manager/wildcard-certificate.yaml # Wildcard Certificate 생성


# K3s Ingress Controller(Traefik) 설정 확인
kubectl get pods -n kube-system | grep traefik  # 기본 설정으로 Traefik이 kube-system 네임스페이스에 설치됨

# Traefik의 인증서 발급 기능 중단
kubectl apply -f ./cert-manager/traefik-disable-acme.yaml



kubectl get pods -n traefik



# Install nextcloud-aio (Traefik Ingress Controller에 별도 등록!)

kubectl apply -f ./nextcloud-aio-for-traefik-ingress-controller/
./nextcloud-AIO-setup.sh

# Talk용 3178 수동 포트포워딩
sudo firewall-cmd --add-port=3178/tcp --permanent
sudo firewall-cmd --add-port=3178/udp --permanent
sudo firewall-cmd --reload