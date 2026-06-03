FROM node:20-alpine
WORKDIR /app
COPY ../../merrygit-chat-service/package*.json ./
RUN npm install
COPY ../../merrygit-chat-service/ .
EXPOSE 5002
CMD ["npm", "run", "dev"]