# Grafana in docker

Tagged docker images for grafana, `grafana/grafana` on docker hub.

## Usage

Use `docker run` as you always do. You need to publish port `80`
(and `443` if you use ssl) in order to have access to grafana.

Container should have access to datasources like graphite,
and will proxy requests to them through itself. You don't
need to expose them to end users of grafana.

### Env variables.

* `GRAFANA_SERVER_NAME` server name for your grafana, for example `grafana.example.com`
* `GRAFANA_ES_SERVERS` elasticsearch servers in `host:port[,host:port]` format
* `GRAFANA_GRAPHITE_SERVERS` graphite servers in `host:port[,host:port]` format
* `GRAFANA_SSL_CERT` path to ssl `.crt` file, enables http-to-https redirect, should be bind-mounted
* `GRAFANA_SSL_KEY` path to ssl `.key` file, should be bind-mounted
* `GRAFANA_ES_INDEX` index name in elasticsearch to save dashboards, `grafana-dash` by default
* `GRAFANA_DEFAULT_ROUTE` default dashboard route, `/dashboard/file/default.json` by default
* `GRAFANA_SEARCH_MAX_RESULTS` limit for dashboard search results, 100 by default
* `GRAFANA_WINDOW_TITLE_PREFIX` window title prefix for grafana, `Grafana - ` by default
* `GRAFANA_UNSAVED_CHANGES_WARNING` warn about unsaved changes, `true` by default
* `GRAFANA_PLAYLIST_TIMESPAN` default timespan for playlists, `1m` by default
* `GRAFANA_SAVING_ADMIN_PASSWORD` password to save dashboards (insecure!)
* `GRAFANA_BASIC_AUTH_LOGIN` basic auth login, if needed
* `GRAFANA_BASIC_AUTH_PASSWORD` hashed basic auth password, if needed
* `GRAFANA_NGINX_INCLUDE_FILE` file to include into main server of nginx (place allowed ips here)

### Example

Running grafana with elasticsearch on `es.dev:9200` and graphite on `graphite.dev:8080`,
exposing it on `grafana.dev` with ip address `10.10.10.10`:

```
docker run -d -p 10.10.10.10:80:80 -e SERVER_NAME=grafana.dev \
    -e ES_SERVERS=es.dev:9200 -e GRAPHITE_SERVERS=graphite.dev:8080 \
    --name grafana grafana/grafana
```

## TODO

* Add support for every datasource supported by grafana
* Add support for multiple datasources at once (and setting default)
