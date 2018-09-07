# The Grafana Docker image has moved

The build for the Grafana docker image has been moved into the main repository. This was done to simplify the build process and to tie a specific version of the docker image to a specific version of Grafana.

This means:
- the open PR's and issues were closed and re-created in the main [repo](https://github.com/grafana/grafana)
  - [docker issue](https://github.com/grafana/grafana/issues?q=is%3Aopen+is%3Aissue+label%3A%22comp%3A+docker%22)
- any new issues should be created [here](https://github.com/grafana/grafana/issues)
- the build lives [here](https://github.com/grafana/grafana/tree/master/packaging/docker), under `packaging/docker`

We'd like to thank everyone who has helped out in creating our Docker image and look forward to keep working with you in its new home.
