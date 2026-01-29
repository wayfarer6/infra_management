### Packer (아무것도 모름)


#### 개요

- VM, 클라우드, 컨테이너용 이미지를 제작해주는 툴 
- "Infrastructure ac Code"를 위한 이미지 제작 툴 

```bash
curl -fsSL https://releases.hashicorp.com/packer/1.11.0/packer_1.11.0_linux_amd64.zip -o packer.zip
unzip packer.zip
sudo mv packer /usr/local/bin/

```

#### 프로젝트 구조 

- main.pkr.hcl → 핵심 설정 파일 (빌더/프로비저너/포스트프로세서 정의)

- variables.pkr.hcl → 변수 정의

- scripts/ → 설치/설정용 쉘 스크립트

- output/ → 빌드된 이미지 결과물

### HCL 기반 문법 

- HashiCorp Configuration Language 

    - Builder : 어떤 플랫폼에, 어떤 이미지를 만들지
    - Provisioner: 이미지 안에서 실행할 설정 / 스크립트
    - Post-Processor: 결과 이미지 후처리 (압축, 업로드 등)