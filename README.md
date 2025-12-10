# Python App Kubernetes Deployment

A production-ready FastAPI application with PostgreSQL, containerized and deployed to Kubernetes (GKE) using Helm, with
comprehensive monitoring and observability stack.

## Overview

This project demonstrates a complete cloud-native deployment of a Python FastAPI application on Kubernetes, following
modern DevOps and SRE practices. The application is fully containerized, monitored, and ready for production use

### Key Features

- **Containerization**: Multi-stage Alpine-based Docker image optimized for size and security
- **Orchestration**: Kubernetes deployment on GKE managed via Helm charts
- **Security**: Non-root containers, secret management
- **Monitoring**: Prometheus metrics collection and Grafana dashboards
- **Scalability**: Horizontal Pod Autoscaler with CPU/Memory metrics
- **High Availability**: Rolling updates
- **Ingress**: Nginx Ingress Controller with LoadBalancer

## Quick Start

### Prerequisites

- Docker
- kubectl
- Helm
- gcloud CLI (for GKE)

### Deployment (GKE)

```bash
docker build -t REGION-docker.pkg.dev/PROJECT_ID/REPOSITORY/IMAGE_NAME .
docker push REGION-docker.pkg.dev/PROJECT_ID/REPOSITORY/IMAGE_NAME:IMAGE_TAG

cd helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

cd python-api
helm dependency update

cd ..
helm upgrade --install python-api python-api \
  -f python-api/values.yaml \
  -f python-api/values-sensitive.yaml \
  --namespace default
```

## Future Improvements

The following features are planned based on the original architecture design:

1. **Loki + Promtail** - Deploy centralized logging stack with Grafana Loki for log aggregation and Promtail for log
   collection across all pods

2. **AlertManager Routing** - Configure alert routing to Slack, email for proper incident
   response workflows

3. **External Secrets Operator** - Integrate with Google Secret Manager to store and sync secrets securely without
   keeping them in Helm values
