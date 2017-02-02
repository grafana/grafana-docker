#!/bin/bash

_grafana_version=$1

if [ "$_grafana_version" != "" ]; then
	echo "push! ${_grafana_version}"
	docker push grafana/grafana:${_grafana_version}
	#docker push grafana/grafana:latest
else
	echo "pushing! master"
	docker push grafana/grafana:master
fi
