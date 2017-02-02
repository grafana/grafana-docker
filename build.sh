#!/bin/bash

_grafana_version=$1

if [ "$_grafana_version" != "" ]; then
	echo "Building version ${_grafana_version}"
	docker build \
		--build-arg DOWNLOAD_URL=https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${_grafana_version}_amd64.deb \
		--tag "grafana/grafana:${_grafana_version}" \
		--no-cache=true .
	docker tag grafana/grafana:${_grafana_version} grafana/grafana:latest

else
	echo "Building latest for master"
	docker build \
		--build-arg DOWNLOAD_URL=https://s3-us-west-2.amazonaws.com/grafana-releases/master/grafana_latest_amd64.deb \
		--tag "grafana/grafana:master" \
		--no-cache=true .
fi



#
#_grafana_version=$1
#_grafana_tag=$2
#_release_build=false

#if [ -z "${_grafana_version}" ]; then
#	source GRAFANA_VERSION
#	_grafana_version=$GRAFANA_VERSION
#	_grafana_tag=$GRAFANA_VERSION
#	_release_build=true
#fi

#echo "GRAFANA_VERSION: ${_grafana_version}"
#echo "DOCKER TAG: ${_grafana_tag}"
#echo "RELEASE BUILD: ${_release_build}"

#docker build --build-arg GRAFANA_VERSION=${_grafana_version} --tag "grafana/grafana:${_grafana_tag}"  --no-cache=true .

#if [ $_release_build == true ]; then
#	docker build --build-arg GRAFANA_VERSION=${_grafana_version} --tag "grafana/grafana:latest"  --no-cache=true .
#fi
