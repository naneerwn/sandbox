#!/bin/bash
set -e

source .env

echo "=== Сборка фронтенда ==="
docker build -t my-frontend:latest ./frontend

echo "=== Пуш в Nexus ==="
echo "$NEXUS_PASS" | docker login -u "$NEXUS_USER" --password-stdin "$NEXUS_HOST"

docker tag my-frontend:latest $NEXUS_HOST/$NEXUS_REPO_FRONTEND/my-frontend:latest
docker push $NEXUS_HOST/$NEXUS_REPO_FRONTEND/my-frontend:latest