FROM node:lts-alpine3.15

ENV NODE_ENV=production

RUN mkdir -p /app

WORKDIR /app

RUN apk update --no-cache
RUN apk add bash git curl ca-certificates jq

RUN npm install -g npm@8.6.0
RUN yarn add eslint@v8.12.0
RUN yarn add eslint-plugin-toml@0.3.1

RUN mkdir -p /app/config
RUN mkdir -p /app/src

COPY config/custom_formatter.js /app/config/custom_formatter.js
COPY config/.eslintrc.base.js /app/config/.eslintrc.base.js
COPY config/.eslintrc.recommended.js /app/config/.eslintrc.recommended.js
COPY config/.eslintrc.standard.js config/.eslintrc.standard.js
COPY src/entrypoint.sh /app/src/entrypoint.sh
COPY src/tomllint.sh /app/src/tomllint.sh

ENV PATH="/app/node_modules/eslint/bin/:${PATH}"

ENTRYPOINT ["/app/src/entrypoint.sh"]
