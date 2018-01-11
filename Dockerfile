FROM debian:jessie

ARG DOWNLOAD_URL
ARG PROJECT_NAME=finn-app 
ENV PROJECT_NAME ${PROJECT_NAME}
RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get clean && \
    curl ${DOWNLOAD_URL} > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ADD "$PROJECT_NAME".ini /etc/grafana/custom.ini
VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3034

COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]
