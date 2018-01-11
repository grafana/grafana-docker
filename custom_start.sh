#!/bin/bash

docker run -i -p 3034:3034 --build-arg PROJECT_NAME=finn-app grafana/grafana:master
