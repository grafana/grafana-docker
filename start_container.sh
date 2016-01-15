#!/bin/bash

docker run -i -p 3001:3000 \
  -v /home/torkel/dev/grafana-docker/data:/var/lib/grafana \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name"  \
  grafana/grafana:2.6.0
