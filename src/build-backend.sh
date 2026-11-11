#!/bin/sh
set -e

# Загружаем переменные из .env
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  . "$SCRIPT_DIR/.env"
  set +a
fi

echo "=== [1/2] Сборка бэкенда ==="
docker build -t my-backend:latest "$SCRIPT_DIR/backend"

if [ -n "$NEXUS_HOST" ]; then
  echo "=== [2/2] Пуш бэкенда в Nexus ==="
  IMAGE_NAME="${NEXUS_HOST}/${NEXUS_REPO_BACKEND}/my-backend:latest"
  
  docker tag my-backend:latest "$IMAGE_NAME"
  
  printf '%s' "$NEXUS_PASS" | docker login -u "$NEXUS_USER" --password-stdin "$NEXUS_HOST"
  docker push "$IMAGE_NAME"
else
  echo "ОШИБКА: Переменная NEXUS_HOST не найдена в .env!"
  exit 1
fi

echo "=== Бэкенд успешно собран и запушен ==="