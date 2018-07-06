Table of Contents
=================

   * [go-demo](#go-demo)
      * [Install pre-requiste tools](#install-pre-requiste-tools)
      * [Start a Kubernetes cluster](#start-a-kubernetes-cluster)
      * [Configure Skaffold](#configure-skaffold)
      * [Build the project](#build-the-project)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# go-demo

Dummy project to demonstrate local kubernetes development using minikube

## Install pre-requiste tools

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://docs.helm.sh/using_helm/#installing-helm)
- [Skaffold](https://github.com/GoogleContainerTools/skaffold#installation)

## Start a Kubernetes cluster

Create a minikube environmnent 

```
minikube start
minikube addons enable ingress
helm init
```

## Configure Skaffold

```
cat <<END > skaffold.yaml
apiVersion: skaffold/v1alpha2
kind: Config
build:
  artifacts:
  - imageName: go-demo
deploy:
  helm:
    releases:
      - name: go-demo
        chartPath: charts/go-demo
        namespace: default
        values:
          image.name: go-demo
        setValues:
          service.port: 8080
          ingress.enabled: true
          ingress.hosts[0]: go-demo.$(minikube ip).nip.io
END
```

## Build the project

Using the minkube docker engine (do not push images)

```
eval $(minikube docker-env)
```

Start skaffold

```
skaffold dev
```

