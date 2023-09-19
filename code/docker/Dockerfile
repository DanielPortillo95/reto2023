FROM node:18.16.0-alpine

#FROM node:alpine 

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 3000

ENTRYPOINT ["node", "index.js"]
