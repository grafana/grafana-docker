#!/bin/bash
DEFAULT_TAG="alpine-glibc"

_grafana_version=$1
_grafana_tag="$2-$DEFAULT_TAG"
_release_build=false

if [ -z "${_grafana_version}" ]; then
	source ../GRAFANA_VERSION
	_grafana_version=$GRAFANA_VERSION
	_grafana_tag="$GRAFANA_VERSION-$DEFAULT_TAG"
	_release_build=true
fi

echo "GRAFANA_VERSION: ${_grafana_version}"
echo "DOCKER TAG: ${_grafana_tag}"
echo "RELEASE BUILD: ${_release_build}"

docker build --build-arg GRAFANA_VERSION=${_grafana_version} --tag "adipirro852/grafana:${_grafana_tag}"  --no-cache=true .

if [ $_release_build == true ]; then
	docker tag "adipirro852/grafana:${_grafana_tag}" "adipirro852/grafana:$DEFAULT_TAG"
fi
