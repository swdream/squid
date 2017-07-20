#!/bin/sh

set -e

SQUID_USERNAME=${USERNAME:-squid}
SQUID_PASSWORD=${PASSWORD:-squid}

QUID_CONFIG_DIR=/etc/squid
SQUID_LOG_DIR=/var/log/squid
SQUID_CACHE_DIR=/var/cache/squid

# default behaviour is to launch squid
htpasswd -bc /etc/squid/passwd "${SQUID_USERNAME}" "${SQUID_PASSWORD}"
chmod 644 /etc/squid/passwd

create_log_dir() {
  if [[ ! -d ${SQUID_LOG_DIR} ]]; then
    echo "creating log dir"
    mkdir -p ${SQUID_LOG_DIR}
  fi
  chmod -R 755 ${SQUID_LOG_DIR}
  # Redirect logs to stdout
  ln -sf /dev/stdout /var/log/squid/access.log
  ln -sf /dev/stdout /var/log/squid/cache.log
  chown -R squid:squid /dev/stdout
  chown -R squid:squid ${SQUID_LOG_DIR}
}

create_cache_dir() {
  if [[ ! -d ${SQUID_CACHE_DIR} ]]; then
    echo "creating cache dir"
    mkdir -p ${SQUID_CACHE_DIR}
  fi
  chmod -R 755 ${SQUID_CACHE_DIR}
  chown -R squid:squid ${SQUID_CACHE_DIR}
}

create_log_dir
create_cache_dir

SQUID_VERSION=$(/usr/sbin/squid -v | grep Version | awk '{ print $4 }')
if [ "$1" == "squid" ]; then
  echo "Staring squid [${SQUID_VERSION}]"
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    exec /sbin/su-exec root /usr/sbin/squid -z
  fi
  exec /sbin/su-exec root /usr/sbin/squid -N
else
  exec "$@"
fi
