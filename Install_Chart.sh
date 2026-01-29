# Install Charts 

helm install devops ./DevOps --namespace devops --create-namespace
helm install entertainment ./Entertainment-Suite --namespace entertainment --create-namespace
helm install self-hosted-sec ./Self-Hosted-Security --namespace self-hosted-security --create-namespace
helm install storage-solutions ./Storage-and-Backup-Suite --namespace storage-solutions --create-namespace