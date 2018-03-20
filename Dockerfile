FROM debian:jessie

ARG GRAFANA_VERSION="latest"
ARG GF_HOME="/usr/share/grafana"

RUN apt-get update && apt-get install -qq -y wget tar sqlite libfontconfig curl ca-certificates && \
    wget -O /tmp/grafana.tar.gz https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-x64.tar.gz && \
    tar -zxvf /tmp/grafana.tar.gz -C /tmp && rm /tmp/grafana.tar.gz && \
    mv /tmp/grafana-* $GF_HOME && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /etc/grafana/provisioning/datasources && \
    mkdir -p /etc/grafana/provisioning/dashboards && \
    mkdir -p /var/lib/grafana/plugins && \
    mkdir -p /var/log/grafana && \
    cp $GF_HOME/conf/sample.ini /etc/grafana/grafana.ini && \
    cp $GF_HOME/conf/ldap.toml /etc/grafana/ldap.toml && \
    cp $GF_HOME/bin/grafana-server /usr/sbin/grafana-server && \
    cp $GF_HOME/bin/grafana-cli /usr/sbin/grafana-cli && \
    chown -R nobody:nogroup /var/lib/grafana && \
    chown -R nobody:nogroup $GF_HOME

VOLUME ["/var/lib/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

USER nobody

ENTRYPOINT [ "/run.sh" ]