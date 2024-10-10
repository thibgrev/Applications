FROM debian:latest

LABEL "author"="thibgrev"

RUN apt-get update && apt-get install --no-install-recommends -y nginx; \
 echo "daemon off;" >> /etc/nginx/nginx.conf
RUN apt-get install curl -y 

COPY index.html /tmp/nginx/index.html
COPY nginx.conf /etc/nginx/conf.d/

RUN chmod -R 0755 /tmp/nginx/index.html
#; chown -R nginx /usr/share/nginx/html

EXPOSE 80

# Start nginx
CMD ["/usr/sbin/nginx"]
