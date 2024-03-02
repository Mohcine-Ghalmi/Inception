FROM debian:stable

RUN apt update  -y
RUN apt upgrade -y
RUN apt install -y nginx openssl
RUN apt install -y openssl
RUN mkdir -p /ssl
RUN openssl genpkey