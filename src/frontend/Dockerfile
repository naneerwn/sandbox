# --- Стадия Builder (сборка) ---
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN NODE_OPTIONS=--openssl-legacy-provider npm run build

# --- Стадия Runtime (запуск) ---
FROM node:20-alpine
WORKDIR /app

RUN npm install -g http-server

COPY --from=builder /app/dist ./dist

EXPOSE 8080

CMD ["http-server", "dist", "-p", "8080", "--proxy", "http://backend:8081"]