#!/bin/sh

_grafana_tag=$1
_grafana_version=${_grafana_tag:1}

if [ "$_grafana_version" != "" ]; then
	echo "pushing grafana/grafana:${_grafana_version}"
	docker push grafana/grafana:${_grafana_version}
	docker push grafana/grafana:latest
else
	echo "pushing grafana/grafana:master"
	docker push grafana/grafana:master
fi
