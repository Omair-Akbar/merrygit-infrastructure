FROM node:20-alpine
WORKDIR /app
COPY ../../merrygit-user-service/package*.json ./
RUN npm install
COPY ../../merrygit-user-service/ .
EXPOSE 5001
CMD ["npm", "run", "dev"]