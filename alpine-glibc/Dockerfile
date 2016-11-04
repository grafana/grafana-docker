FROM alpine:3.4

ARG GRAFANA_VERSION

RUN apk add --no-cache openssl \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
    && apk add glibc-2.23-r3.apk \
    && wget https://grafanarel.s3.amazonaws.com/builds/grafana-$GRAFANA_VERSION.linux-x64.tar.gz \
    && tar -xzf grafana-$GRAFANA_VERSION.linux-x64.tar.gz \
    && mv grafana-$GRAFANA_VERSION/ grafana/ \
    && sed -i 's,data = data,data = data/db,g' grafana/conf/defaults.ini \
    && rm grafana-$GRAFANA_VERSION.linux-x64.tar.gz /etc/apk/keys/sgerrand.rsa.pub glibc-2.23-r3.apk\
    && apk del openssl

VOLUME ["/grafana/conf", "/grafana/data/db", "/grafana/data/log", "/grafana/data/plugins"]

EXPOSE 3000

WORKDIR /grafana
CMD ["./bin/grafana-server"]
