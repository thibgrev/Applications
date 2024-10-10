FROM debian:latest

LABEL thibgrev

COPY ./index.html /usr/share/html/

RUN apt-get update && apt-get install --no-install-recommends -y nginx; \
 echo "daemon off;" >> /etc/nginx/nginx.conf
RUN apt-get install curl -y 
RUN chmod -R 0755 /usr/share/nginx/html


EXPOSE 80

# Start nginx
CMD ["/usr/sbin/nginx"]
