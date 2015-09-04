# Grafana docker image

This container runs Grafana 2.1.0.

## Building the image

Run:
  `docker build --rm -t grafana .`


## Running the image

To run the image with its default settings,

Run:
  `docker run -i -p 3000:3000 grafana`


To run the image with custom settings, you'll likely want to consult
http://docs.grafana.org/installation/configuration/. In particular
note that all configuration going into the ini files can be overriden
using environment variables.

For example, to use a postgres database,

Run:

  ```
  echo 'GF_DATABASE_TYPE=postgres' >> envfile
  echo 'GF_DATABASE_HOST=<pg_host>' > envfile
  echo 'GF_DATABASE_USER=<pg_user>' > envfile
  echo 'GF_DATABASE_PASSWORD=<pg_pass>' > envfile
  docker run --env-file=envfile -p 3000:3000 -d grafana
  ```