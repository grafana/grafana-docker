# Grafana docker image

This container builds a container with the
latest master build of Grafana.

2.0.2 -> 2.1.0 Upgrade NOTICE!

The data and log paths were not correct in the previous image. The grafana database was placed by default in /usr/share/grafana/data instead of the correct path /var/lib/grafana. This means it was not in a dir that was marked as a volume. So if you remove the container it will remove the grafana database. So before updating make sure you copy the /usr/share/grafana/data path from inside the container to the host.

This container currently only contains the latest Grafana release.


## Running your Grafana image
--------------------------

Start your image binding the external port `3000`.

   docker run -i -p 3000:3000 grafana/grafana

Try it out, default admin user is admin/admin.


## Configuring your Grafana container

All options defined in conf/grafana.ini can be overriden using environment variables, for example:

```
docker run -i -p 3000:3000 \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name"  \
  -e "GF_SECURITY_ADMIN_PASSWORD=secret"  \
  grafana/grafana
```



