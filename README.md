# Squid proxy

## Quickstart

Start Squid:

```
docker run --rm --name squid -e USERNAME=foo -e PASSWORD=bar -p 3128:3128 --volume /srv/docker/squid/:/var/cache/squid -d swdream/squid:3.5.23
```
