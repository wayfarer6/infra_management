# infra_management



# - 기존에 Plane과 Element Server Suite도 있음을 감안하고 설계함


### 알아야 하는 개념 정리

🧩 Helm 핵심 개념
Chart: 애플리케이션 패키지 단위 (하나의 서비스 = 하나의 Chart)

Release: 특정 Chart를 Kubernetes 클러스터에 배포한 인스턴스

Values: 템플릿에 주입되는 설정값 (환경별로 다르게 적용 가능)

Templates: Kubernetes YAML을 동적으로 생성하는 Go 템플릿 파일

Repository: 차트를 저장하고 배포할 수 있는 저장소


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

