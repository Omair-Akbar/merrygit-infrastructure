FROM node:20-alpine
WORKDIR /app
COPY ../../merrygit-chat-service/package*.json ./
RUN npm install
COPY ../../merrygit-chat-service/ .
RUN npm run build
EXPOSE 5002
CMD ["npm", "run", "start"]