FROM debian:stretch-slim

ARG GRAFANA_VERSION="latest"
ARG GF_HOME="/usr/share/grafana"
ARG GF_UID="472"
ARG GF_GID="472"

RUN apt-get update && apt-get install -qq -y tar sqlite libfontconfig curl ca-certificates && \
    curl -o /tmp/grafana.tar.gz https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-x64.tar.gz && \
    tar -zxvf /tmp/grafana.tar.gz -C /tmp && rm /tmp/grafana.tar.gz && \
    mv /tmp/grafana-* $GF_HOME && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g $GF_GID grafana && \
    useradd -r -u $GF_UID -g grafana grafana && \
    mkdir -p /etc/grafana/provisioning/datasources && \
    mkdir -p /etc/grafana/provisioning/dashboards && \
    mkdir -p /var/lib/grafana/plugins && \
    mkdir -p /var/log/grafana && \
    cp $GF_HOME/conf/sample.ini /etc/grafana/grafana.ini && \
    cp $GF_HOME/conf/ldap.toml /etc/grafana/ldap.toml && \
    cp $GF_HOME/bin/grafana-server /usr/sbin/grafana-server && \
    cp $GF_HOME/bin/grafana-cli /usr/sbin/grafana-cli && \
    chown -R grafana:grafana /var/lib/grafana && \
    chown -R grafana:grafana $GF_HOME && \
    chown -R grafana:grafana /var/log/grafana

ARG GF_INSTALL_PLUGINS=""

RUN if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then \
      OLDIFS=$IFS; \
      IFS=','; \
      for plugin in ${GF_INSTALL_PLUGINS}; do \
        IFS=$OLDIFS; \
        grafana-cli --pluginsDir "/var/lib/grafana/plugins" plugins install ${plugin}; \
      done; \
    fi

VOLUME ["/var/lib/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

USER grafana

ENTRYPOINT [ "/run.sh" ]
