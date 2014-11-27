FROM ubuntu:14.04

# upgrade
RUN apt-get update
RUN apt-get upgrade -y

# needed packages
RUN apt-get install -y --no-install-recommends python-pip curl nginx-core
RUN pip install envtpl

# nginx
ADD nginx.conf.tpl /etc/nginx/nginx.conf.tpl

# grafana
ENV GRAFANA_VERSION 1.8.1
RUN curl -s "http://grafanarel.s3.amazonaws.com/grafana-${GRAFANA_VERSION}.tar.gz" | \
    tar xz -C /tmp && mv "/tmp/grafana-${GRAFANA_VERSION}" /grafana
ADD grafana.js.tpl /grafana/config.js.tpl

# run script
ADD ./run.sh ./run.sh

# logs
VOLUME ["/var/log/nginx"]

# ports
EXPOSE 80 443

ENTRYPOINT ["/run.sh"]
