#!/bin/bash

_grafana_version=$1

_docker_repo=${2:-grafana/grafana}

if [ "$_grafana_version" != "" ]; then
	echo "Building version ${_grafana_version}"
	docker build \
		--build-arg GRAFANA_VERSION=${_grafana_version} \
		--tag "${_docker_repo}:${_grafana_version}" \
		--no-cache=true .
	docker tag ${_docker_repo}:${_grafana_version} ${_docker_repo}:latest
else
	echo "Building latest for master"
	docker build \
		--tag "grafana/grafana:master" \
		.
fi
