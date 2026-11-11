#!/bin/bash
set -e

source .env

echo "=== Сборка бэкенда ==="
docker build -t my-backend:latest ./backend

echo "=== Пуш в Nexus ==="
echo "$NEXUS_PASS" | docker login -u "$NEXUS_USER" --password-stdin "$NEXUS_HOST"

docker tag my-backend:latest $NEXUS_HOST/$NEXUS_REPO_BACKEND/my-backend:latest
docker push $NEXUS_HOST/$NEXUS_REPO_BACKEND/my-backend:latest