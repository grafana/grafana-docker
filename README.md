# Grafana 2.0 in docker container

Tagged docker images for grafana, `grafana/grafana` on docker hub.

## Usage

```
docker run -i \
  -p 3000:3000 \
  grafana/grafana:develop
```

The container has the database in a volume at /opt/grafana/data


