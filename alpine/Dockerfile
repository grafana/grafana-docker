FROM alpine:3.4

ARG GRAFANA_VERSION

RUN apk add --no-cache openssl \
    && wget https://github.com/adipirro/grafana-musl/releases/download/v$GRAFANA_VERSION/grafana-$GRAFANA_VERSION.musl-linux-x64.tar.gz \
    && tar -xzf grafana-$GRAFANA_VERSION.musl-linux-x64.tar.gz \
    && mv grafana-$GRAFANA_VERSION/ grafana/ \
    && sed -i 's,data = data,data = data/db,g' grafana/conf/defaults.ini \
    && rm grafana-$GRAFANA_VERSION.musl-linux-x64.tar.gz \
    && apk del openssl

VOLUME ["/grafana/conf", "/grafana/data/db", "/grafana/data/log", "/grafana/data/plugins"]

EXPOSE 3000

WORKDIR /grafana
CMD ["./bin/grafana-server"]
