# infra_management


### Anaconda 를 통한 OS 설치 자동화 

- git repo에 있는 kickstarter 폴더 usb에 넣기

How to Use
Step-by-Step Instructions
Boot from the Rocky Linux ISO (8 or 9).

When the GRUB menu appears, highlight Install Rocky Linux (but do not press Enter).

Press e to edit the boot parameters.

Find the line starting with:

linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Rocky-9-3-x86_64-dvd quiet
Append your Kickstart file URL to the end of the line:

inst.ks=http://<your-ip>/kickstart_rocky9.cfg
Boot with Ctrl+X or F10 to start the automated installation.

Example
linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Rocky-9-3-x86_64-dvd quiet inst.ks=http://192.168.1.1/kickstart_rocky9.cfg

⚙️ Kickstart 적용 방법
ISO에 포함: ks.cfg 파일을 ISO에 삽입 후 부팅 옵션에 inst.ks=cdrom:/ks.cfg 추가

네트워크 경로 사용: inst.ks=http://server/ks.cfg 옵션으로 Kickstart 파일 불러오기

커스텀 ISO 제작: mkisofs 또는 xorriso로 Kickstart 포함 ISO 생성


출처: https://github.com/fnateghi/rocky-kickstart

### Ansible를 통한 VM 설정 자동화 (추후 적용예정)

# - 기존에 Plane과 Element Server Suite도 있음을 감안하고 설계함


### 알아야 하는 개념 정리

🧩 Helm 핵심 개념
Chart: 애플리케이션 패키지 단위 (하나의 서비스 = 하나의 Chart)

Release: 특정 Chart를 Kubernetes 클러스터에 배포한 인스턴스

Values: 템플릿에 주입되는 설정값 (환경별로 다르게 적용 가능)

Templates: Kubernetes YAML을 동적으로 생성하는 Go 템플릿 파일

Repository: 차트를 저장하고 배포할 수 있는 저장소

Ingress: 각 네임 스페이스별로 정의 됨, Ingress Controller(NGINX, Traefik 등)가 이를 읽어 라우팅 테이블을 구성, 각 서비스의 접근을 가능하게 함.
 - Ingress는 네임스페이스 단위로 정의되지만, Ingress Controller는 클러스터 전체를 바라본다 , 햇갈리지 말자.

## Deployment
- pod를 어떻게 실행할지 정의
- 이미지 , replica 수
- 컨테이너 포트, 환경 변수, 리소스 요청 / 제한 
- 업데이트 전략


## Service 

- pod 들이 네트워크 상에서 접근 가능하게 만드는 추상화 계층

- pod를 묶어서 하나의 엔드 포인트 (ip/port) 제공
- ClusterIP,nodeport,loadbalancer 
- 로드 밸런싱 제공

### Monitoring
- VictoriaMetrics


### 기타 

- 편의성을 위해  wireguard 사용!
- 기존에 쓰던 Nextcloud aio를 포기할 수 없어 사용함.
- jenkins의 경우 컨테이너를 띄워서 도커로 특히 써서 빌드 하기에 docker 컨테이너를 실행하는 설정까지 주어야 해서 인터넷 뒤져서 알아냄

- AI 도움을 받아서 빠르게 공부함... (복잡한 설정등은 추후에 더 공부해야 겠음)

- configmap으로 해야하는 줄 알앗는데 helm으로 템플릿처럼 할수 있게됨. (2026-01-28)

#### 잘 만들어졌는지 테스트

```bash
# 1번 문법 검사
helm lint.

# helm 에 설정된 입력 값 확인
helm template.


```


- k3s 인증서 및 Ingress 정리

## cert-manager (전역)

클러스터 전체에서 사용할 ClusterIssuer를 하나만 만듭니다.

이 ClusterIssuer는 와일드카드 인증서를 발급할 수 있도록 설정합니다.

예: *.example.com 와일드카드 인증서 → Secret(wildcard-cert-tls)에 저장.

## Ingress (네임스페이스별)

애플리케이션은 각자의 네임스페이스에 배포됩니다.

각 네임스페이스마다 Ingress를 정의합니다.

Ingress에서 cert-manager.io/cluster-issuer annotation을 붙이고, tls.secretName을 지정하면 cert-manager가 자동으로 인증서를 발급합니다.

와일드카드 인증서를 공통으로 쓰고 싶다면 Secret을 복제하거나 공유하는 방식(kubed 같은 도구)을 사용합니다.


## 설치 순서 

# 필수 유틸리티 설치 및 방화벽 설정 

# duckdns 설정 (이거는 각자 알아서)

# k3s 초기 설정 (cert-manager 설치, 와일드카드 인증서 발급)

   # kubectl apply 순서(Secret → ClusterIssuer → Certificate → Ingress)

# 각 차트 설치


# nextcloud aio의 경우에는 traefik 에 별도 등록 해야 함

```bash

kubectl apply -f ingress.yaml -f service.yaml

# 또는 kubectl apply -f ./nextcloud-aio-for-traefik-ingress-controller/

```

### Optional (Packer를 통한 gold image 만들기)

- Packer로 구울때 Ansible을 호출해서 필요한 네트워크,보안,스토리지,패키지 설치 후 vhd나 ami 등으로 뽑아낼수 있음.

#### Ansible를 통한 vps 설정 관리 

- Ansible을 통해 전체 vps의 설정을 일치시키고, 코드를 통해 전체 인프라의 보안 강화, 인프라 정책 수정등을 용이하게 관리 가능함.

- CI/CD 시 이미지 빌드 파이프라인과 인프라 배포 파이프 라인 구분하면 됨.
