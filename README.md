Table of Contents
=================

   * [go-demo](#go-demo)
      * [Install pre-requiste tools](#install-pre-requiste-tools)
      * [Configure environment](#configure-environment)
      * [Run the demo](#run-the-demo)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# go-demo

Dummy project to demonstrate Kubernetes Draft

## Install pre-requiste tools

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Draft](https://draft.sh/)

## Configure environment

Create a minikube environmnent with an ingress controller, helm and draft installed

```
minikube start
minikube addons enable ingress
helm init
draft init 
```
Wait until all the pods are running and k8s has reached a steady state

```
kubectl get pods --all-namespaces -w
```

Configure docker client to use the docker engine running within the minikube VM.

```
eval $(minikube docker-env)
draft config set disable-push-warning 1
```

## Run the demo

Initialize the project, generates a helm chart and docker file

```
draft create
```

Run the build

```
draft up
```

In another window you can monitor the build

```
draft logs --tail
```

To access the application, you can run a proxy:

```
$ draft connect -p 8080:8080
Connect to go:8080 on localhost:8080
[go]: + exec app
```

And see the output locally:

http://localhost:8080/Joe

## Other features

### Build logs

Check the build history

```
$ draft history
BUILD_ID                  	CONTEXT_ID	CREATED_AT              	RELEASE
01CATRV0P9EYF8C7XJ9FCA2KJJ	903C5CC089	Wed Apr 11 17:33:38 2018	go-demo
```


## Bugs

### Expose the application via an Ingress

> TODO: 
> Waiting for issue [#223](https://github.com/Azure/draft/issues/223) to be delivered, then will be able to assign 
> helm overrides that will enable to deployment of an Ingress to expose the application.

### Watcher not working

Couple of open issues. This was working in v0.11.0

- [#341](https://github.com/Azure/draft/issues/341)
- [#3](https://github.com/Azure/draft/issues/3)

This a pity as we'd like to redeploy automatically upon code changes.
