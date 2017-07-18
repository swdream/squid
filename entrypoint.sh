#!/bin/sh

set -e

SQUID_USERNAME=${USERNAME:-squip}
SQUID_PASSWORD=${PASSWORD:-squip}

# default behaviour is to launch squid
htpasswd -bc /etc/squid/passwd "${SQUID_USERNAME}" "${SQUID_PASSWORD}"

SQUID_VERSION=$(/usr/sbin/squid -v | grep Version | awk '{ print $4 }')
if [ "$1" == "squid" ]; then
  echo "Staring squid [${SQUID_VERSION}]"
  /usr/sbin/squid -z
  /usr/sbin/squid
else
  exec "$@"
fi
