#!/bin/bash
_grafana_version=$1
_grafana_tag=$2

if [ -z "${_grafana_version}" ]; then
	source GRAFANA_VERSION
	_grafana_version=$GRAFANA_VERSION
	_grafana_tag=$GRAFANA_VERSION
fi

echo "GRAFANA_VERSION: ${_grafana_version}"
echo "DOCKER TAG: ${_grafana_tag}"

docker build --build-arg GRAFANA_VERSION=${_grafana_version} --tag "grafana/grafana:${_grafana_tag}"  --no-cache=true .
