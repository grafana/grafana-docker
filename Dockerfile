FROM debian:wheezy

RUN apt-get update && apt-get -y install libfontconfig wget

RUN wget http://grafanarel.s3.amazonaws.com/builds/grafana_latest_amd64.deb

RUN dpkg -i grafana_latest_amd64.deb

EXPOSE 3000

VOLUME ["/opt/data"]
VOLUME ["/etc/grafana"]

WORKDIR /opt/grafana/current

ENTRYPOINT ["/opt/grafana/current/grafana", "--config", "/etc/grafana/grafana.ini", "web"]
