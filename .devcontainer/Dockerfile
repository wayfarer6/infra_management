FROM mcr.microsoft.com/devcontainers/base:ubuntu

# git-lfs 설치
RUN apt-get update && \
    apt-get install -y git-lfs && \
    rm -rf /var/lib/apt/lists/*

# git-lfs 초기화
RUN git lfs install
