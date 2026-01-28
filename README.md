# infra_management



# - 기존에 Plane과 Element Server Suite도 있음을 감안하고 설계함


### 알아야 하는 개념 정리

🧩 Helm 핵심 개념
Chart: 애플리케이션 패키지 단위 (하나의 서비스 = 하나의 Chart)

Release: 특정 Chart를 Kubernetes 클러스터에 배포한 인스턴스

Values: 템플릿에 주입되는 설정값 (환경별로 다르게 적용 가능)

Templates: Kubernetes YAML을 동적으로 생성하는 Go 템플릿 파일

Repository: 차트를 저장하고 배포할 수 있는 저장소