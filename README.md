
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

Install the helm starter repo

```
git clone git@github.com:Teamwork/helm-teamwork-starter.git $(helm home)/starters/teamwork
rm -rf $(helm home)/starters/teamwork/.git
```

## Start a Kubernetes cluster

Create a minikube environmnent 

```
minikube start --vm-driver kvm2 --cpus 2 --memory 4096 
helm init
```

## Getting started

Configure environment to use docker inside the minikube VM

```
eval $(minikube docker-env)
```

Run a Dev session

```
make
skaffold dev
```

App should be available via a port mapping

- http://localhost:8080

# Miscellaneous

## Registry port forwarding

In order to push images from the local docker to registry running on minikube.

```
kubectl -n kube-system port-forward deployment/docker-registry 5000:5000
```

