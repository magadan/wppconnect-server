FROM sitespeedio/node:ubuntu-20.04-nodejs-16.5.0 as base
WORKDIR /usr/src/wpp-server
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN apt-get update
COPY package.json yarn.lock ./

FROM base as build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json yarn.lock ./
COPY . .


FROM base
WORKDIR /usr/src/wpp-server/
RUN apt-get install chromium -y
COPY . .
COPY --from=build /usr/src/wpp-server/ /usr/src/wpp-server/
EXPOSE 21465
ENTRYPOINT ["node", "dist/server.js"]
