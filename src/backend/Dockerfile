# --- Стадия Builder (сборка) ---
FROM golang:1.22-alpine AS builder
WORKDIR /app

# Копируем файлы зависимостей и качаем их
COPY go.mod go.sum ./
RUN go mod download

# Копируем весь исходный код и собираем бинарник
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server ./cmd/api/

# --- Стадия Runtime (запуск) ---
# Используем тот же образ, что и для сборки (как просил препод)
FROM golang:1.22-alpine
WORKDIR /app

# Копируем только скомпилированный бинарник из стадии builder
COPY --from=builder /app/server .

# Открываем порт (если твой бэкенд слушает другой порт, поменяй здесь)
EXPOSE 8081

# Запускаем бинарник
CMD ["./server"]