### 프로젝트 폴더 구조
- ansible.cfg: 인벤토리 경로, SSH 연결 설정 등을 정의.

- inventory/: 호스트 IP, 그룹, 사용자 등을 관리.

- roles/: 작업(tasks), 핸들러(handlers), 템플릿 등을 기능 단위로 분리.

- group_vars/: 인벤토리 그룹별 변수를 관리하여 플레이북과 변수를 분리.

- site.yml: 여러 역할을 통합하여 실행하는 최상위 플레이북. 