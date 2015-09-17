
FROM debian:jessie

RUN apt-get -y update && \
	apt-get -y install \
	wget \
	libfontconfig \
	adduser

RUN wget http://grafanarel.s3.amazonaws.com/builds/grafana_latest_amd64.deb && \
	dpkg -i grafana_latest_amd64.deb

RUN rm -rf grafana_latest_amd64.deb && \
	apt-get -y remove wget && \
	apt-get -y --purge autoremove && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3000

VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]
VOLUME ["/etc/grafana"]

WORKDIR /usr/share/grafana

ENTRYPOINT ["/usr/sbin/grafana-server", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.logs=/var/log/grafana"]
