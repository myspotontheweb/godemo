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
```

Configure additional software

```
minikube addons enable ingress
helm init
helm install stable/docker-registry -n registry --namespace default --set service.nodePort=30500,service.type=NodePort
```

Expose remote services locally

```
sudo kubefwd services --namespace default
```

## Build the project

Build and push image

```
docker build -t registry-docker-registry:5000/go-demo:latest .
docker push registry-docker-registry:5000/go-demo:latest
```

Deploy image using localhost

```
kubectl run go-demo --image localhost:30500/go-demo:latest --port 8080
kubectl expose deployment go-demo
```

