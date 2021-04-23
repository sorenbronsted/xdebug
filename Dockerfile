FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install apache2 iputils-ping php php-xdebug netcat net-tools dnsutils telnet && phpenmod xdebug

EXPOSE 80
CMD apachectl -D FOREGROUND