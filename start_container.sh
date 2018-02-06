#!/bin/bash

docker run -i -p 3001:3000 \
  -v /home/torkel/dev/grafana-docker/data:/var/lib/grafana \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name"  \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel,grafana-simple-json-datasource  1.2.3" \
  grafana/grafana:latest
