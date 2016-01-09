# Grafana Docker image

This project builds a Docker image with the latest master build of Grafana.

2.0.2 -> 2.1.0 Upgrade NOTICE!

The data and log paths were not correct in the previous image. The grafana
database was placed by default in /usr/share/grafana/data instead of the correct
path /var/lib/grafana. This means it was not in a dir that was marked as a
volume. So if you remove the container it will remove the grafana database. So
before updating make sure you copy the /usr/share/grafana/data path from inside
the container to the host.

## Running your Grafana container

Start your container binding the external port `3000`.

```
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

Try it out, default admin user is admin/admin.

## Configuring your Grafana container

All options defined in conf/grafana.ini can be overriden using environment
variables, for example:

```
docker run \
  -d \
  --name=grafana \
  -p 3000:3000 \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
  -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
  grafana/grafana
```

## Grafana container with persistent storage (recommended)

```
# create /var/lib/grafana as persistent volume storage
docker run -d -v /var/lib/grafana --name grafana-storage busybox:latest

# start grafana
docker run \
  -d \
  --name=grafana \
  -p 3000:3000 \
  --volumes-from grafana-storage \
  grafana/grafana
```

## Start specific version of Grafana XXL

```
# specify right tag, e.g. 2.6.0 - see Docker Hub for available tags
docker run \
  -d \
  --name=grafana \
  -p 3000:3000 \
  --name grafana \
  grafana/grafana:2.6.0
```

## Official Grafana with unofficial plugins (community project):

Unofficial plugins/datasources: Zabbix, DalmatinerDB, Ambari, Atsd, Bosun,
Cloudera Manager, Druid, Chnocchi, PRTG, ...

```
# create /var/lib/grafana as persistent volume storage
docker run -d -v /var/lib/grafana --name grafana-xxl-storage busybox:latest

# start grafana-xxl
docker run \
  -d \
  -p 3000:3000 \
  --name grafana-xxl \
  --volumes-from grafana-xxl-storage \
  monitoringartist/grafana-xxl
```

Visit [Grafana XXL project](https://github.com/monitoringartist/grafana-xxl)
for more details.