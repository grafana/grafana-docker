#!/bin/bash

_grafana_version=$1

_docker_repo=${2:-grafana/grafana}

if [ "$_grafana_version" != "" ]; then
	echo "Building version ${_grafana_version}"
	docker build \
		--build-arg GRAFANA_URL="https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${_grafana_version}.linux-x64.tar.gz" \
		--tag "${_docker_repo}:${_grafana_version}" \
		--no-cache=true .
	docker tag ${_docker_repo}:${_grafana_version} ${_docker_repo}:latest
else
	echo "Building latest for master"
	docker build \
		--tag "grafana/grafana:master" \
		.
fi
