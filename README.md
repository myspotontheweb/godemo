
Table of Contents
=================

   * [go-demo](#go-demo)
      * [Install pre-requiste tools](#install-pre-requiste-tools)
      * [Start a Kubernetes cluster](#start-a-kubernetes-cluster)
      * [Build the project](#build-the-project)
         * [Enable ingress](#enable-ingress)

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
minikube start --vm-driver kvm2 --cpus 2 --memory 4096 
```

Configure additional software

```
minikube addons enable ingress
helm init
```

## Build the project

Configure environment to use docker inside the minikube VM

```
eval $(minikube docker-env)
```

Run a Dev session

```
skaffold dev
```

App should be available via a port mapping

- http://localhost:8080

### Enable ingress

Edit the skaffold file to define the basedomain supported by minikube

```
cat << END > skaffold.yaml
apiVersion: skaffold/v1alpha5
kind: Config
build:
  artifacts:
  - image: go-demo
deploy:
  helm:
    releases:
      - name: go-demo
        chartPath: chart
        namespace: default
        values:
          image.name: go-demo
        setValues:
          ingress.enabled: true
          basedomain: $(minikube ip).nip.io
END
```

