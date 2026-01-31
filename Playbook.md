
## Packer 와 Ansible을 이용한 VHD 이미지 생성 

- 본 프로젝트는 Virtualbox를 기반으로 작동합니다
- 원한다면 Vmware 및 다른 플랫폼으로 전환하실 수 있습니다. 


### Packer 설치 및 설정 

```bash

```

1. Packer를 통해 정해진 규격의 임시 Vm이 생성 됩니다.
2. kickstart에 설정된 값에 따라 OS 설치 옵션이 지정, 설치 됩니다.
3. OS 설치 이후 Ansible이 VM에 필요한 k3s 및 주요 패키지와, 방화벽 등 각종 설정을 진행합니다.


### K3s 설정 및 Cert 발급

- openssl로 발급한 Cert는 SealedSecret 통해 암호화된 Secret를 복구하는 키 입니다. private , public key는 안전한 장소에 별도 보관해 주세요.


### Velero 설정 및 S3 자동 백업

- 본 프로젝트에서는 `storage` 네임스페이스에 miniO 컨테이너를 이용하여 모든 k3s namespace를 백업합니다.


### 주요 어플리케이션 설정하기 


### Portforwarding 및 cert-manager를 이용한 ssl 인증서 발급

- 참고: cloudflare 터널도 같이 사용하는게 더 안전합니다.

### 리소스 관리하기 

### Kubernetes RBAC 설정하기 

- 기본 설정값 

1. `devops` 네임 스페이스  

### Multi-Node로 확장시

- 본 프로젝트는 SingleNode를 가정하고 작성된 프로젝트 임으로 application마다 별도 설정을 참고 해주세요 

- 사용된 application

차트명 이름 설명
1.
2.
3.
4.
5.


