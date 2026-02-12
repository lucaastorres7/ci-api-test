FROM node:24.13-alpine3.23 AS build

WORKDIR /usr/src/app
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

# Esse comando é opcional, mas pode ser útil para remover dependências de desenvolvimento e reduzir o tamanho da imagem final
RUN npm ci --only=production

FROM node:24.13-alpine3.23 AS production

WORKDIR /usr/src/app
EXPOSE 3000

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./

CMD [ "npm", "run", "start:prod" ]
