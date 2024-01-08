FROM nginx:stable
COPY nginx.conf /etc/nginx/nginx.conf
RUN apt -y update
RUN apt -y install nginx-extras libnginx-mod-http-dav-ext libnginx-mod-http-auth-pam