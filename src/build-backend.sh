#!/bin/sh
set -e # Остановить выполнение при ошибке

echo "=== Старт сборки бэкенда ==="

# 1. Логин в GitLab Registry (используем встроенные переменные GitLab)
if [ -n "$CI" ]; then
  echo "$CI_REGISTRY_PASSWORD" | docker login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY"
fi

# 2. Сборка (проверь путь: если backend в src/, то ./src/backend)
docker build -t my-backend:latest ./src/backend

# 3. Пуш в Registry (только если мы в CI)
if [ -n "$CI" ]; then
  docker tag my-backend:latest "$CI_REGISTRY_IMAGE/backend:$CI_COMMIT_SHA"
  docker tag my-backend:latest "$CI_REGISTRY_IMAGE/backend:latest"
  
  docker push "$CI_REGISTRY_IMAGE/backend:$CI_COMMIT_SHA"
  docker push "$CI_REGISTRY_IMAGE/backend:latest"
fi

echo "=== Сборка завершена ==="