#!/bin/bash -e

: "${GF_PATHS_CONFIG:=/etc/grafana/grafana.ini}"
: "${GF_PATHS_DATA:=/var/lib/grafana}"
: "${GF_PATHS_LOGS:=/var/log/grafana}"
: "${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}"

chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_LOGS"
chown -R grafana:grafana /etc/grafana

if [ ! -z ${GF_AWS_PROFILES+x} ]; then
    mkdir -p ~grafana/.aws/
    touch ~grafana/.aws/credentials

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

if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then
  OLDIFS=$IFS
  IFS=','
  for plugin in ${GF_INSTALL_PLUGINS}; do
    IFS=$OLDIFS
    grafana-cli  --pluginsDir "${GF_PATHS_PLUGINS}" plugins install ${plugin}
  done
fi

# Open a shell subprocess, whait until grafana starts and POST datasources
# If the pod is killed it restarts with preconfigured dashboards
# The downsize is that if the admin username and password is changed it is not
# automaticaly updated.
(
cd /etc/grafana
until $(curl --silent --fail --show-error --output /dev/null http://admin:admin@127.0.0.1:3000/api/datasources); do
  printf '.' ; sleep 1 ;
done ;
for file in *-datasource.json ; do
  if [ -e "$file" ] ; then
    echo "importing $file" &&
    curl --silent --fail --show-error \
    --request POST http://admin:admin@127.0.0.1:3000/api/datasources \
    --header "Content-Type: application/json" \
    --data-binary "@$file" ;
    echo "" ;
  fi
done ;
for file in *-dashboard.json ; do
  if [ -e "$file" ] ; then
    # wrap exported Grafana dashboard into valid json
    echo "importing $file" &&
    (echo '{"dashboard":';cat "$file";echo ',"inputs":[{"name":"DS_PROMETHEUS","pluginId":"prometheus","type":"datasource","value":"prometheus"}]}') | curl --silent --fail --show-error \
    --request POST http://admin:admin@127.0.0.1:3000/api/dashboards/import \
    --header "Content-Type: application/json" \
    --data-binary @-;
    echo "" ;
  fi
done ;
) &


exec gosu grafana /usr/sbin/grafana-server      \
  --homepath=/usr/share/grafana                 \
  --config="$GF_PATHS_CONFIG"                   \
  cfg:default.log.mode="console"                \
  cfg:default.paths.data="$GF_PATHS_DATA"       \
  cfg:default.paths.logs="$GF_PATHS_LOGS"       \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS" \
  "$@"
