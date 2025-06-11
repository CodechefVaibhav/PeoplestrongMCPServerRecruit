# ---------- builder stage ----------
FROM node:20.12.2-slim AS builder
WORKDIR /opt

# Install dev deps and build
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---------- runtime stage ----------
FROM node:20.12.2-alpine
WORKDIR /opt
ENV NODE_ENV=production

# Copy your environment file so dotenv can load it
COPY .env ./

# Copy only the built files from builder
COPY --from=builder /opt/dist          ./dist
COPY --from=builder /opt/src/prompts   ./dist/prompts
COPY package*.json ./
RUN npm ci --omit=dev

EXPOSE 8000
CMD ["node","dist/server.js"]
