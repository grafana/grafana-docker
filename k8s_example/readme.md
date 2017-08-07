# Grafana kubernetes deployment example.

Prerequisite:
 - configure your prometheus service in `/config/prometheus-datasource.json`

## Create service and deployment

    kubectl --kubeconfig=./kube/config --context=test1 --namespace=monitoring apply -f ./k8s-grafana/grafana-dpl.yaml
    kubectl --kubeconfig=./kube/config --context=test1 --namespace=monitoring apply -f ./k8s-grafana/grafana-svc.yaml
    kubectl --kubeconfig=./kube/config --context=test1 --namespace=monitoring create configmap grafana-config --from-file=./k8s-grafana/config
