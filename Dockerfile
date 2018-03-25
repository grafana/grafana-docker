FROM debian:stretch-slim

ARG GRAFANA_VERSION="latest"
ARG GF_UID="472"
ARG GF_GID="472"

ENV GF_PATHS_CONFIG="/etc/grafana/grafana.ini"
ENV GF_PATHS_DATA="/var/lib/grafana"
ENV GF_PATHS_HOME="/usr/share/grafana"
ENV GF_PATHS_LOGS="/var/log/grafana"
ENV GF_PATHS_PLUGINS="/var/lib/grafana/plugins"
ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN apt-get update && apt-get install -qq -y tar sqlite libfontconfig curl ca-certificates && \
    mkdir -p "$GF_PATHS_HOME" && \
    curl https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-x64.tar.gz | tar xfvz - --strip-components=1 -C "$GF_PATHS_HOME" && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g $GF_GID grafana && \
    useradd -r -u $GF_UID -g grafana grafana && \
    mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
             "$GF_PATHS_PROVISIONING/dashboards" \
             "$GF_PATHS_PLUGINS" \
             "$GF_PATHS_LOGS" && \
    cp "$GF_PATHS_HOME/conf/sample.ini" "$GF_PATHS_CONFIG" && \
    cp "$GF_PATHS_HOME/conf/ldap.toml" /etc/grafana/ldap.toml && \
    cp "$GF_PATHS_HOME/bin/grafana-server" /usr/sbin/grafana-server && \
    cp "$GF_PATHS_HOME/bin/grafana-cli" /usr/sbin/grafana-cli && \
    chown -R grafana:grafana "$GF_PATHS_DATA" && \
    chown -R grafana:grafana "$GF_PATHS_HOME" && \
    chown -R grafana:grafana "$GF_PATHS_LOGS"

ARG GF_INSTALL_PLUGINS=""

RUN if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then \
      OLDIFS=$IFS; \
      IFS=','; \
      for plugin in ${GF_INSTALL_PLUGINS}; do \
        IFS=$OLDIFS; \
        grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install ${plugin}; \
      done; \
    fi

VOLUME [$GF_PATHS_DATA]

EXPOSE 3000

COPY ./run.sh /run.sh

USER grafana

ENTRYPOINT [ "/run.sh" ]
