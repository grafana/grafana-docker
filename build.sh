#!/bin/bash

_grafana_version=$1

if [ "$_grafana_version" != "" ]; then
	echo "Building version ${_grafana_version}"
	docker build \
		--build-arg GRAFANA_VERSION=${_grafana_version} \
		--tag "grafana/grafana:${_grafana_version}" \
		--no-cache=true .
	docker tag grafana/grafana:${_grafana_version} grafana/grafana:latest

else
	echo "Building latest for master"
	docker build \
		--tag "grafana/grafana:master" \
		.
fi
