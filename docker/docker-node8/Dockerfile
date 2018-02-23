FROM node:8.9.4-alpine

RUN npm install pm2@2.9.3 mocha@4.1.0 -g && \
    mkdir -p /var/app /var/log/tas

WORKDIR /var/app

CMD ["sh"]
