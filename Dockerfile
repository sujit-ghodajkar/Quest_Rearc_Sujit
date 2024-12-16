FROM node:22.12.0-alpine3.21

WORKDIR /

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "src/000.js"]