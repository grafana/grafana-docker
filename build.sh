#!/bin/bash

_grafana_tag=$1
_grafana_version=${_grafana_tag:1}

if [ "$_grafana_version" != "" ]; then
	echo "Building version ${_grafana_version}"
	echo "Download url: https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${_grafana_version}_amd64.deb"
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
