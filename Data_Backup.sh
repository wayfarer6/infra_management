#!/bin/bash

echo "Starting data backup process..."

mkdir K3s_Backup_DIR
cd K3s_Backup_DIR 


echo "Backuping up K3s Secrets..."

# namespace 목록 가져오기
namespaces=$(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}")

# 각 namespace의 secrets 백업
#for ns in $namespaces; do
#    echo "Backing up secrets in namespace: $ns"
#    kubectl get secrets -n $ns -o yaml > "backup_secrets_${ns}.yaml"
#done

# 전체 클러스터면 
kubectl get secret --all-namespaces -o yaml > all-secrets.yaml

# K3s 설정 백업

#설정 파일

#/etc/rancher/k3s/config.yaml → 클러스터 설정 (API 서버, 토큰, 네트워크 옵션 등)

#/etc/systemd/system/k3s.service → 서비스 실행 옵션

#데이터 디렉토리

#/var/lib/rancher/k3s/ → etcd 데이터, kubeconfig, 인증서, StorageClass 데이터 등

# 특히 /var/lib/rancher/k3s/server/tls/ → 클러스터 TLS 인증서

#/var/lib/rancher/k3s/server/db/ → etcd DB (클러스터 상태)



sudo tar -czvf k3s-backup-$(date +%F).tar.gz /etc/rancher/k3s /var/lib/rancher/k3s

# Velero 백업

## K3s 일시 중단 

# 원래 Replica 수 

echo "Stopping k3s Pods..."

echo "Current Deployments and StatefulSets in namespace:"
kubectl get deployment --all-namespaces
kubectl get statefulset --all-namespaces

# Deployment replicas 저장
kubectl get deployment --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,REPLICAS:.spec.replicas > deployments-replicas.txt

# StatefulSet replicas 저장
kubectl get statefulset --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,REPLICAS:.spec.replicas > statefulsets-replicas.txt

#pod 중단
kubectl scale deployment --all --replicas=0 --all-namespaces
kubectl scale statefulset --all --replicas=0 --all-namespaces
# Deployment/StatefulSet 스케일 다운을 통한 안전한 중단

kubectl scale deployment --all --replicas=0 -n devops
kubectl scale statefulset --all --replicas=0 -n devops


# k3s 재시작 


# 모든 네임스페이스의 Deployment/StatefulSet replicas 복원 스크립트 
# 중단 전에 저장해둔 replicas 파일을 참고합니다.

DEPLOY_FILE="deployments-replicas.txt"
STATEFUL_FILE="statefulsets-replicas.txt"

# Deployment 복원
if [ -f "$DEPLOY_FILE" ]; then
  echo "Restoring Deployments from $DEPLOY_FILE ..."
  while read ns name replicas; do
    if [[ "$ns" != "NAMESPACE" ]]; then
      echo "Scaling deployment $name in namespace $ns to $replicas replicas"
      kubectl scale deployment "$name" -n "$ns" --replicas="$replicas"
    fi
  done < "$DEPLOY_FILE"
else
  echo "Deployment replicas file not found!"
fi

# StatefulSet 복원
if [ -f "$STATEFUL_FILE" ]; then
  echo "Restoring StatefulSets from $STATEFUL_FILE ..."
  while read ns name replicas; do
    if [[ "$ns" != "NAMESPACE" ]]; then
      echo "Scaling statefulset $name in namespace $ns to $replicas replicas"
      kubectl scale statefulset "$name" -n "$ns" --replicas="$replicas"
    fi
  done < "$STATEFUL_FILE"
else
  echo "StatefulSet replicas file not found!"
fi

echo "복원이 완료되었습니다!"

# 최종 압축

sudo tart -czvf K3s_Backup_$(date +%F).tar.gz ./