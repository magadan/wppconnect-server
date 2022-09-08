FROM sitespeedio/node:ubuntu-20.04-nodejs-16.5.0 as base
WORKDIR /usr/src/wpp-server
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN apt-get update
COPY package.json yarn.lock ./
RUN npm install

FROM base as build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json yarn.lock ./
RUN yarn install --production=false --pure-lockfile && \
    yarn cache clean
COPY . .
RUN npm build


FROM base
WORKDIR /usr/src/wpp-server/
RUN apt-get install chromium -y
RUN yarn cache clean
COPY . .
COPY --from=build /usr/src/wpp-server/ /usr/src/wpp-server/
EXPOSE 21465
ENTRYPOINT ["node", "dist/server.js"]
