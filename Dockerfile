FROM node:24.22.2-alpine3.23

WORKDIR /app

COPY package.json package-lock.json ./

RUN apk add --no-cache openssl curl gcompat iproute2 coreutils bash \
    && npm ci --omit=dev \
    && npm cache clean --force

COPY index.js ./

EXPOSE 3000/tcp

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:3000/').then(()=>process.exit(0)).catch(()=>process.exit(1))"

USER node

CMD ["node", "index.js"]
