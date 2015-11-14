FROM socrata/base

ENV GRAFANA_VERSION 2.5.0

RUN apt-get update && \
    apt-get -y install libfontconfig wget adduser openssl ca-certificates && \
    apt-get clean && \
    wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb -O /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb

ADD ship.d /etc/ship.d

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000
