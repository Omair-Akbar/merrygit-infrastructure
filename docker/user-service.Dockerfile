FROM node:20-alpine
WORKDIR /app
COPY ../../merrygit-user-service/package*.json ./
RUN npm install  --legacy-peer-deps
COPY ../../merrygit-user-service/ .
RUN npm run build
EXPOSE 5000
CMD ["npm", "run", "start"]