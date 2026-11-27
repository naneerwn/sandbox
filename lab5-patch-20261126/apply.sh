#!/usr/bin/env bash
# Применяет изменения лабораторной работы к проекту студента.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="${SCRIPT_DIR}/files"

if [ "$#" -ne 1 ]; then
  echo "Использование: $0 <путь-к-проекту>" >&2
  exit 1
fi

TARGET_DIR="$1"
if [ ! -d "${TARGET_DIR}" ]; then
  echo "Ошибка: директория '${TARGET_DIR}' не существует" >&2
  exit 1
fi
TARGET_DIR="$(cd "${TARGET_DIR}" && pwd)"

echo "Копирование файлов в ${TARGET_DIR}"
cp -av "${FILES_DIR}/." "${TARGET_DIR}/"

ENV_FILE="${TARGET_DIR}/.env"
touch "${ENV_FILE}"

add_env() {
  local key="$1"
  local value="$2"

  if grep -qE "^[[:space:]]*${key}=" "${ENV_FILE}"; then
    return
  fi

  # Если файл не заканчивается переводом строки, добавляем его,
  # чтобы переменная не склеилась с последней строкой.
  if [ -s "${ENV_FILE}" ] && [ -n "$(tail -c 1 "${ENV_FILE}")" ]; then
    printf '\n' >> "${ENV_FILE}"
  fi

  printf '%s=%s\n' "${key}" "${value}" >> "${ENV_FILE}"
  echo "Добавлено в .env: ${key}=${value}"
}

add_env DB_ENABLED false
add_env DB_HOST postgres
add_env DB_PORT 5432
add_env DB_USER postgres
add_env DB_PASSWORD postgres
add_env DB_NAME postgres
add_env DB_SSLMODE disable

echo
echo "Готово."
echo "Внимание: файл docker-compose.yml был перезаписан целиком."
echo "Дальнейшие шаги:"
echo "  1. Проверьте .env: для включения интеграции установите DB_ENABLED=true."
echo "  2. При необходимости обновите зависимости: (cd ${TARGET_DIR}/src/backend && go mod tidy)."
echo "  3. Запустите сервисы: docker compose up -d"
