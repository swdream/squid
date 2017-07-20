FROM alpine:3.3
MAINTAINER Swdream "ngtthanh1010@gmail.com"

ENV SQUID_CONFIG_DIR=/etc/squid

RUN apk update && \
    apk add --no-cache su-exec squid=3.5.23-r0 apache2-utils && \
    rm -rf /var/cache/apk/*

RUN mv ${SQUID_CONFIG_DIR}/squid.conf ${SQUID_CONFIG_DIR}/squid.conf.dist

COPY entrypoint.sh /
COPY conf/squid.conf /etc/squid/squid.conf

EXPOSE 3128

VOLUME ["/var/cache/squid"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["squid"]
