FROM debian:jessie
MAINTAINER Vivek Lanjekar <vivek.lanjekar@gmail.com>

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget libpcre3-dev build-essential libssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget http://nginx.org/download/nginx-1.12.2.tar.gz && \
    tar -zxvf nginx-1.*.tar.gz && \
    cd nginx-1.* && \
    ./configure --prefix=/opt/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_v2_module --with-ipv6 --with-threads --with-stream --with-stream_ssl_module && \
    make && make install && \
    cd .. && rm -rf nginx-1.*

# nginx user
RUN adduser --system --no-create-home --disabled-login --disabled-password --group nginx

# config dirs
RUN mkdir /opt/nginx/http.conf.d && mkdir /opt/nginx/stream.conf.d

ADD nginx.conf /opt/nginx/conf/nginx.conf
ADD zero_downtime_reload.sh /opt/nginx/sbin/zero_downtime_reload.sh

WORKDIR /

EXPOSE 3306 8126

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
