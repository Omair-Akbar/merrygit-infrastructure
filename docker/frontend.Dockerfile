FROM node:20-alpine
WORKDIR /app
COPY ../../merrygit/package*.json ../../merrygit/pnpm-lock.yaml* ./
RUN npm install -g pnpm && pnpm install
COPY ../../merrygit/ .
EXPOSE 3000
CMD ["pnpm", "dev"]