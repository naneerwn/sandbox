# --- СТАДИЯ 1: BUILDER (Сборка) ---
FROM node:20-alpine AS builder
WORKDIR /app

# 1. Копируем файлы зависимостей для кэширования
COPY package.json package-lock.json ./

# 2. Используем npm ci (чистая установка строго по lock-файлу)
# --ignore-scripts отключает потенциально опасные скрипты при установке
RUN npm ci --ignore-scripts

# 3. Копируем исходники и собираем
COPY . .
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build

# 4. Удаляем dev-зависимости, чтобы не тащить их в финальный образ
RUN npm prune --production

# --- СТАДИЯ 2: PROD (Финальный образ) ---
FROM node:20-alpine

WORKDIR /app

# Устанавливаем только http-server
RUN npm install -g http-server

# Копируем только собранную статику (dist) из стадии builder
COPY --from=builder /app/dist ./dist

EXPOSE 8080
CMD ["http-server", "dist", "-p", "8080"]