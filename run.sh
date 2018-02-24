#!/bin/bash -e

# TODO : 
# - implement more env variables like protocol, url etc
# - better daemonization
# - test multiple datasource import
# - add dashboard import

: "${GF_PATHS_CONFIG:=/etc/grafana/grafana.ini}"
: "${GF_PATHS_DATA:=/var/lib/grafana}"
: "${GF_PATHS_LOGS:=/var/log/grafana}"
: "${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}"
: "${GF_PATHS_PROVISIONING:=/etc/grafana/provisioning}"

# Default values
if [ -z "${GF_SECURITY_ADMIN_USER}" ]; then
  echo "Using standard admin username"
  export GF_SECURITY_ADMIN_USER="admin"
fi

if [ -z "${GF_SECURITY_ADMIN_PASSWORD}" ]; then
  echo "Using standard admin password"
  export GF_SECURITY_ADMIN_PASSWORD="admin"
fi

if [ -z "${GF_SERVER_HTTP_PORT}" ]; then
  echo "Using standard server port"
  export GF_SERVER_HTTP_PORT="3000"
fi

if [ -z "${GF_SERVER_PROTOCOL}" ]; then
  echo "Using standard HTTP protocol"
  export GF_SERVER_PROTOCOL="http"
fi




chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_LOGS"

if [ ! -z ${GF_AWS_PROFILES+x} ]; then
    mkdir -p ~grafana/.aws/
    > ~grafana/.aws/credentials

    for profile in ${GF_AWS_PROFILES}; do
        access_key_varname="GF_AWS_${profile}_ACCESS_KEY_ID"
        secret_key_varname="GF_AWS_${profile}_SECRET_ACCESS_KEY"
        region_varname="GF_AWS_${profile}_REGION"

        if [ ! -z "${!access_key_varname}" -a ! -z "${!secret_key_varname}" ]; then
            echo "[${profile}]" >> ~grafana/.aws/credentials
            echo "aws_access_key_id = ${!access_key_varname}" >> ~grafana/.aws/credentials
            echo "aws_secret_access_key = ${!secret_key_varname}" >> ~grafana/.aws/credentials
            if [ ! -z "${!region_varname}" ]; then
                echo "region = ${!region_varname}" >> ~grafana/.aws/credentials
            fi
        fi
    done

    chown grafana:grafana -R ~grafana/.aws
    chmod 600 ~grafana/.aws/credentials
fi

# Install plugins
if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then
  OLDIFS=$IFS
  IFS=','
  for plugin in ${GF_INSTALL_PLUGINS}; do
    IFS=$OLDIFS
    gosu grafana grafana-cli --pluginsDir "${GF_PATHS_PLUGINS}" plugins install ${plugin}
  done
fi

# Start server
exec gosu grafana /usr/sbin/grafana-server              \
  --homepath=/usr/share/grafana                         \
  --config="$GF_PATHS_CONFIG"                           \
  cfg:default.log.mode="console"                        \
  cfg:default.paths.data="$GF_PATHS_DATA"               \
  cfg:default.paths.logs="$GF_PATHS_LOGS"               \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS"         \
  cfg:default.paths.provisioning=$GF_PATHS_PROVISIONING \
  "$@" &



# Wait for complete service startup
while ! nc -z localhost $GF_SERVER_HTTP_PORT; do   
  sleep 1
done
echo "----------------"


if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then
  echo "Enabling plugins:"
  OLDIFS=$IFS
  IFS=','
  for plugin in ${GF_INSTALL_PLUGINS}; do
    IFS=$OLDIFS
    curl -v -XPOST "$GF_SERVER_PROTOCOL://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@localhost:$GF_SERVER_HTTP_PORT/api/plugins/$plugin/settings?enabled=true" -d ''
  done
fi


if [ ! -z "${GF_DATASOURCES}" ]; then
  echo "Importing datasources:"
  OLDIFS=$IFS
  IFS=';'
  for ds in ${GF_DATASOURCES}; do
    curl -H "Content-Type: application/json" -XPOST -d "$( echo $ds  )" $GF_SERVER_PROTOCOL://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@localhost:$GF_SERVER_HTTP_PORT/api/datasources 
  done
fi




# do not exit, keep it running
wait $( pidof grafana-server )
