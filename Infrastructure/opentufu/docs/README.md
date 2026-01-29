
### 폴더 구조

- main.tf: Terraform / OpenTofu 코드 (리소스 정의)
- variables.tf : 변수 정의
- outputs.tf : 출력값 정의 (예: VM: IP, 이미지 ID 등)
- provider.tf : 클라우드 Provider 설정 (이 프로젝트에서는 쓰지 않음)
- modlues : 모듈화된 코드 (네트워크 , VM, 스토리지 등)
- ci-cd : 배포 파이프라인

### 환경별 설정 

- DEV (개발 환경)

- Staging ( Production과 유사한 환경 , 배포전 테스트)

- Prod

