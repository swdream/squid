FROM alpine:3.3
MAINTAINER Swdream "ngtthanh1010@gmail.com"

ENV SQUID_CONFIG_DIR=/etc/squid

RUN apk update && \
    apk add --no-cache squid=3.5.23-r0 apache2-utils

RUN mv ${SQUID_CONFIG_DIR}/squid.conf ${SQUID_CONFIG_DIR}/squid.conf.dist
RUN  mkdir -p /var/cache/squid
RUN chown -R squid:squid /var/cache/squid

COPY entrypoint.sh /
COPY conf/squid.conf /etc/squid/squid.conf

EXPOSE 3128

ENTRYPOINT ["/entrypoint.sh"]
CMD ["squid"]
