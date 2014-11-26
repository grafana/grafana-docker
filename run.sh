#!/bin/sh

set -e

envtpl /etc/nginx/nginx.conf.tpl
envtpl /grafana/config.js.tpl

if [ ! -z "${GRAFANA_BASIC_AUTH_LOGIN}" ]; then
    echo "${GRAFANA_BASIC_AUTH_LOGIN}:${GRAFANA_BASIC_AUTH_PASSWORD}" > /etc/nginx/grafana.htpasswd
fi

exec nginx
