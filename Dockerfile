# ---------- runtime stage ----------
FROM node:20.12.2-alpine
WORKDIR /opt
ENV NODE_ENV=production
COPY dist /opt/dist
COPY src/prompts /opt/dist/prompts
COPY package*.json ./
RUN npm ci --omit=dev
EXPOSE 3000
CMD [ "node", "dist/server.js" ]