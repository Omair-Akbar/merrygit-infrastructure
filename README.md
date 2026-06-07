# MerryGit Infrastructure

This repository contains the complete container infrastructure for [MerryGit](https://github.com/Omair-Akbar/merrygit) — a scalable, real-time chat application built with a microservices architecture.

---

## Architecture Overview

MerryGit is split into 4 independent microservices, each containerized with its own Dockerfile and deployed to Kubernetes.

| Service | Tech Stack | Port |
|---|---|---|
| Frontend | Next.js, TypeScript, TailwindCSS | 3000 |
| Chat Service | Node.js, Express.js, Socket.IO, MongoDB | 5002 |
| User Service | Node.js, Express.js, MongoDB, Redis, RabbitMQ | 5000 |
| Mail Service | Python, FastAPI, RabbitMQ, Resend API | 8000 |

---

## Repository Structure

```
merrygit-infrastructure/
├── docker/
│   ├── frontend.Dockerfile
│   ├── chat-service.Dockerfile
│   ├── user-service.Dockerfile
│   └── mail-service.Dockerfile
└── k8s/
    ├── namespace.yaml
    ├── configmap.yaml
    ├── secret.example.yaml       # Template — copy to secret.yaml and fill in real values
    ├── frontend-deployment.yaml
    ├── frontend-service.yaml
    ├── chat-deployment.yaml
    ├── chat-service.yaml
    ├── user-deployment.yaml
    ├── user-service.yaml
    ├── mail-deployment.yaml
    └── mail-service.yaml
```

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) with Kubernetes enabled
- `kubectl` configured and pointing to your cluster
- All 4 service repositories cloned alongside this repo

Expected folder structure on your machine:

```
DevOps-project/
├── merrygit/                  # Frontend
├── merrygit-chat-service/
├── merrygit-user-service/
├── merrygit-mail-service/
└── merrygit-infrastructure/   # This repo
```

---

## Getting Started

### 1. Build Docker Images

Run from the `docker/` directory so relative paths resolve correctly:

```bash
cd docker/

docker build -f frontend.Dockerfile        -t merrygit-frontend:v1  ../..
docker build -f chat-service.Dockerfile    -t merrygit-chat:v1      ../..
docker build -f user-service.Dockerfile    -t merrygit-user:v1      ../..
docker build -f mail-service.Dockerfile    -t merrygit-mail:v1      ../..
```

### 2. Configure Secrets

```bash
cp k8s/secret.example.yaml k8s/secret.yaml
```

Open `k8s/secret.yaml` and fill in your real values:

```yaml
stringData:
  JWT_SECRET: "your_actual_jwt_secret"
  MONGO_URI: "mongodb+srv://..."
  # ... etc
```

> `secret.yaml` is in `.gitignore` and will never be committed.

### 3. Deploy to Kubernetes

```bash
cd k8s/

kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml

kubectl apply -f frontend-deployment.yaml -f frontend-service.yaml
kubectl apply -f chat-deployment.yaml     -f chat-service.yaml
kubectl apply -f user-deployment.yaml     -f user-service.yaml
kubectl apply -f mail-deployment.yaml     -f mail-service.yaml
```

### 4. Verify All Pods Are Running

```bash
kubectl get all -n merrygit
```

Expected output:

```
NAME                                READY   STATUS    RESTARTS   AGE
pod/chat-service-xxx                1/1     Running   0          ...
pod/frontend-xxx                    1/1     Running   0          ...
pod/mail-service-xxx                1/1     Running   0          ...
pod/user-service-xxx                1/1     Running   0          ...
```

### 5. Access the Frontend

The frontend is exposed via NodePort. Get the assigned port:

```bash
kubectl get service frontend-service -n merrygit
```

Then open your browser at:

```
http://localhost:<NODE_PORT>
```

---

## Kubernetes Configuration

### ConfigMap (`configmap.yaml`)
Stores non-sensitive configuration: service URLs, app names, port numbers, RabbitMQ reconnect settings, and email sender details.

### Secret (`secret.yaml`)
Stores sensitive credentials: JWT secret, MongoDB URI, Cloudinary keys, RabbitMQ credentials, Redis credentials, and Resend API key. This file is **gitignored** — use `secret.example.yaml` as a template.

### Service Types

| Service | K8s Type | Reason |
|---|---|---|
| frontend-service | NodePort | Public access from browser |
| chat-service | ClusterIP | Internal only |
| user-service | ClusterIP | Internal only |
| mail-service | ClusterIP | Internal only |

---

## Useful Commands

```bash
# Check pod logs
kubectl logs -f <pod-name> -n merrygit

# Describe a pod (debug errors)
kubectl describe pod <pod-name> -n merrygit

# Delete and reapply everything
kubectl delete namespace merrygit
kubectl apply -f namespace.yaml
# then re-apply all other files

# Check all resources in namespace
kubectl get all -n merrygit
```

---

## Related Repositories

| Repo | Description |
|---|---|
| [merrygit](https://github.com/Omair-Akbar/merrygit) | Next.js Frontend |
| [merrygit-chat-service](https://github.com/Omair-Akbar/merrygit-chat-service) | Chat microservice |
| [merrygit-user-service](https://github.com/Omair-Akbar/merrygit-user-service) | User microservice |
| [merrygit-mail-service](https://github.com/Omair-Akbar/merrygit-mail-service) | Mail microservice |

---

## Author

**Muhammad Omair Akbar**
[GitHub](https://github.com/Omair-Akbar) · [LinkedIn](https://linkedin.com/in/omair-akbar)
