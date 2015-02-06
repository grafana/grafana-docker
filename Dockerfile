FROM dockerfile/nodejs

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin


ENV GF_REPO_URL https://github.com/grafana/grafana.git
ENV GF_GO_PATH /go/src/github.com/grafana/grafana

RUN apt-get -y update
RUN apt-get -y install libfontconfig

RUN   mkdir -p /go/src/github.com/grafana             &&\
      git clone -b develop $GF_REPO_URL $GF_GO_PATH   &&\
      cd $GF_GO_PATH                                  &&\
      go run build.go setup                           &&\
      go run build.go build                           &&\
      npm install                        &&\
      npm install -g grunt-cli           &&\
      grunt release                      &&\
      mkdir -p /opt/grafana              &&\
      cd tmp                             &&\
      cp -r * /opt/grafana

EXPOSE 3000

VOLUME ["/opt/grafana/data"]

WORKDIR /opt/grafana
ENTRYPOINT ["/opt/grafana/grafana", "web"]
