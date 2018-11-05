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
minikube start --vm-driver kvm2 --memory 4096 --kubernetes-version v1.9.8
minikube addons enable ingress
helm init
```

## Build the project

WIP
