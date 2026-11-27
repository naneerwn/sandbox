# --- СТАДИЯ 1: BUILDER (Сборка и тесты) ---
FROM golang:1.22-alpine AS builder
WORKDIR /app

# 1. Сначала копируем только файлы зависимостей (редко меняются)
# Это позволяет Docker закэшировать слой со скачиванием модулей
COPY go.mod go.sum ./
RUN go mod download

# 2. Копируем весь остальной код (меняется часто)
COPY . .

# 3. Собираем статический бинарник
# -ldflags="-s -w" удаляет отладочную информацию, уменьшая размер файла в 2 раза
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server ./cmd/api/

# --- СТАДИЯ 2: PROD (Финальный образ) ---
FROM alpine:3.19

# Добавляем сертификаты (вдруг понадобятся для HTTPS запросов)
RUN apk --no-cache add ca-certificates

WORKDIR /app

# Копируем ТОЛЬКО скомпилированный бинарник из стадии builder
COPY --from=builder /app/server .

# Безопасность: запускаем не от root, а от пользователя nobody
USER nobody

EXPOSE 8081
CMD ["./server"]