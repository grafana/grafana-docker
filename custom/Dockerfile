ARG GRAFANA_VERSION="latest"

FROM grafana/grafana:${GRAFANA_VERSION}

USER root

# install git
RUN apt-get -y update && apt-get -y install git

RUN git clone --depth=1 --branch change-new-relic-logo https://github.com/YotpoLtd/grafana-newrelic-apm-datasource.git /var/lib/grafana/plugins/grafana-newrelic-apm-datasource

USER grafana
