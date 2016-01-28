_grafana_tag=$1

if [ -z "${_grafana_tag}" ]; then
	source GRAFANA_VERSION
	_grafana_tag=$GRAFANA_VERSION
fi

docker push grafana/grafana:${_grafana_tag}