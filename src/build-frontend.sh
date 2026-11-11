#!/bin/sh
set -e

# Загружаем переменные из .env
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  . "$SCRIPT_DIR/.env"
  set +a
fi

echo "=== [1/2] Сборка фронтенда ==="
docker build -t my-frontend:latest "$SCRIPT_DIR/frontend"

if [ -n "$NEXUS_HOST" ]; then
  echo "=== [2/2] Пуш фронтенда в Nexus ==="
  IMAGE_NAME="${NEXUS_HOST}/${NEXUS_REPO_FRONTEND}/my-frontend:latest"
  
  docker tag my-frontend:latest "$IMAGE_NAME"
  
  printf '%s' "$NEXUS_PASS" | docker login -u "$NEXUS_USER" --password-stdin "$NEXUS_HOST"
  docker push "$IMAGE_NAME"
else
  echo "ОШИБКА: Переменная NEXUS_HOST не найдена в .env!"
  exit 1
fi

echo "=== Фронтенд успешно собран и запушен ==="