
Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [Quickstart](#quickstart)
      * [Install pre-requiste tools](#install-pre-requiste-tools)
      * [Start a Kubernetes cluster](#start-a-kubernetes-cluster)
      * [Running skaffold](#running-skaffold)
   * [Hosted kubernetes cluster with a private registry](#hosted-kubernetes-cluster-with-a-private-registry)
      * [Install private registry](#install-private-registry)
      * [Deploy application](#deploy-application)

        
# Quickstart

Dummy project to demonstrate local kubernetes development using minikube

## Install pre-requiste tools

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://docs.helm.sh/using_helm/#installing-helm)
- [Skaffold](https://github.com/GoogleContainerTools/skaffold#installation)

Install the [helm starter repo](https://github.com/Teamwork/helm-teamwork-starter)

```
git clone git@github.com:Teamwork/helm-teamwork-starter.git $(helm home)/starters/teamwork
rm -rf $(helm home)/starters/teamwork/.git
```

## Start a Kubernetes cluster

```
minikube start --vm-driver kvm2 --cpus 2 --memory 4096 
helm init
```

## Running skaffold

Run a Dev session

```
make
skaffold dev
```

App should be available via a port mapping

- http://localhost:8080

# Hosted kubernetes cluster with a private registry

## Install private registry

NOTE: This requires cluster admin privs. Ideally a k8s cluster used for development will be setup in advance

When running on a hosted cluster check available storage classes

```
kubectl get sc
```

and install a private registry with with a proxy for supporting "localhost"

```
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo update
helm install --namespace kube-system stable/docker-registry --name docker-registry --set persistence.enabled=true,persistence.storageClass=default
helm install --namespace kube-system incubator/kube-registry-proxy --name docker-registry-proxy --set registry.host=docker-registry,registry.port=5000,hostPort=5000
```

Check to ensure pods are running

```
$ kubectl -n kube-system get pods -l "app in (docker-registry,docker-registry-proxy-kube-registry-proxy)"
NAME                                              READY     STATUS    RESTARTS   AGE
docker-registry-5d76f5d9ff-vm8z5                  1/1       Running   0          2m
docker-registry-proxy-kube-registry-proxy-4pnkf   1/1       Running   0          2m
docker-registry-proxy-kube-registry-proxy-kcgpz   1/1       Running   0          2m
```

## Deploy application

Run a proxy locally in order to push images to the cluster

```
kubectl -n kube-system port-forward deployment/docker-registry 5000:5000
```

and run Skaffold to build and deploy the code

```
TILLER_NAMESPACE=default skaffold dev --profile hosted
```

NOTE:

* There is currently [no direct support for specifying a tiller namespace](https://github.com/GoogleContainerTools/skaffold/issues/1183) in the skaffold file

Skaffold will perform a port mapping for the deployed app

- http://localhost:8080

