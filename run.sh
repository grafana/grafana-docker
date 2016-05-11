#!/bin/sh -e

: "${GF_PATHS_DATA:=/var/lib/grafana}"
: "${GF_PATHS_LOGS:=/var/log/grafana}"
: "${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}"

# Run setcap for user only if attempting to use a privileged port
if [ ! -z "${GF_SERVER_HTTP_PORT}" ] && [ $((GF_SERVER_HTTP_PORT < 1024)) = 1 ]; then
  setcap 'cap_net_bind_service=+ep' /usr/sbin/grafana-server
fi

chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_LOGS"
chown -R grafana:grafana /etc/grafana

exec gosu grafana /usr/sbin/grafana-server  \
  --homepath=/usr/share/grafana             \
  --config=/etc/grafana/grafana.ini         \
  cfg:default.paths.data="$GF_PATHS_DATA"   \
  cfg:default.paths.logs="$GF_PATHS_LOGS"   \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS"
