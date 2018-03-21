# Grafana Docker image

[![CircleCI](https://circleci.com/gh/grafana/grafana-docker.svg?style=svg)](https://circleci.com/gh/grafana/grafana-docker)

This project builds a Docker image with the latest master build of Grafana.

## Running your Grafana container

Start your container binding the external port `3000`.

```
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

Try it out, default admin user is admin/admin.

In case port 3000 is closed for external clients or you there is no access 
to the browser - you may test it by issuing:
  curl -i localhost:3000/login
Make sure that you are getting "...200 OK" in response.
After that continue testing by modifying your client request to grafana.

## Configuring your Grafana container

All options defined in conf/grafana.ini can be overriden using environment
variables by using the syntax `GF_<SectionName>_<KeyName>`.
For example:

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
  -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
  grafana/grafana
```

You can use your own grafana.ini file by using environment variable `GF_PATHS_CONFIG`.

More information in the grafana configuration documentation: http://docs.grafana.org/installation/configuration/

## Grafana container with persistent storage (recommended)

```
# create a persistent volume for your data in /var/lib/grafana (database and plugins)
docker volume create grafana-storage

# start grafana
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana
```

Note: An unnamed volume will be created for you when you boot Grafana,
using `docker volume create grafana-storage` just makes it easer to find.

## Installing plugins for Grafana 3

Pass the plugins you want installed to docker with the `GF_INSTALL_PLUGINS` environment variable as a comma seperated list. This will pass each plugin name to `grafana-cli plugins install ${plugin}`.

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  grafana/grafana
```

## Building a custom Grafana image with pre-installed plugins

Dockerfile:
```Dockerfile
FROM grafana/grafana:master
ENV GF_PATHS_PLUGINS=/opt/grafana-plugins
USER root
RUN mkdir -p $GF_PATHS_PLUGINS && chown nobody:nogroup $GF_PATHS_PLUGINS
USER nobody
RUN grafana-cli --pluginsDir $GF_PATHS_PLUGINS plugins install grafana-clock-panel && \
    grafana-cli --pluginsDir $GF_PATHS_PLUGINS plugins install grafana-simple-json-datasource
```

Add lines with `grafana-cli ...` for each plugin you wish to install in your custom image. Don't forget to specify what version of Grafana you wish to build from (replace master in the example).

Example of how to build and run:
```bash
docker build -t grafana:master-with-plugins . 
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  grafana:master-with-plugins
```

## Running specific version of Grafana

```
# specify right tag, e.g. 2.6.0 - see Docker Hub for available tags
docker run \
  -d \
  -p 3000:3000 \
  --name grafana \
  grafana/grafana:2.6.0
```

## Configuring AWS credentials for CloudWatch support

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_AWS_PROFILES=default" \
  -e "GF_AWS_default_ACCESS_KEY_ID=YOUR_ACCESS_KEY" \
  -e "GF_AWS_default_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" \
  -e "GF_AWS_default_REGION=us-east-1" \
  grafana/grafana
```

You may also specify multiple profiles to `GF_AWS_PROFILES` (e.g.
`GF_AWS_PROFILES=default another`).

Supported variables:

- `GF_AWS_${profile}_ACCESS_KEY_ID`: AWS access key ID (required).
- `GF_AWS_${profile}_SECRET_ACCESS_KEY`: AWS secret access  key (required).
- `GF_AWS_${profile}_REGION`: AWS region (optional).

## Changelog

### v4.2.0
* Plugins are now installed into ${GF_PATHS_PLUGINS}
* Building the container now requires a full url to the deb package instead of just version
* Fixes bug caused by installing multiple plugins

### v4.0.0-beta2
* Plugins dir (`/var/lib/grafana/plugins`) is no longer a separate volume

### v3.1.1
* Make it possible to install specific plugin version https://github.com/grafana/grafana-docker/issues/59#issuecomment-260584026

