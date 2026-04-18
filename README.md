# deps-infra

This repo containers the Helm chart that contains Redis and RabbitMQ services to deploy them to DEPS namespace in Kubernetes clusters.

# How to update RabbitMQ or Redis image version?

1. Build a Docker image and push it to EPAM Artifactory.
2. Upgrade image version in .gitlab-ci.yml and Helm chart values files.
3. Run deploy jobs to apply changes.

# Run locally using skaffold 

# !Note make sure that context is rancher-desktop
```bash 
kubectl config current-context 
```

Do the following commands:
```bash
make skaffold
```