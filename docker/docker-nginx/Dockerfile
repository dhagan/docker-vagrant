FROM nginx:1.13.9-alpine

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]
