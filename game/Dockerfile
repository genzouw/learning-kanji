FROM node:15.9.0-alpine as node

RUN mkdir /tmp/work

WORKDIR /tmp/work

COPY package.json .
COPY yarn.lock .

RUN yarn install || true

COPY . .

RUN yarn build

# ---

FROM httpd:2.4.43-alpine

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /usr/local/apache2/conf/httpd.conf

COPY --from=node /tmp/work/dist /usr/local/apache2/htdocs
