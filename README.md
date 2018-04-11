Table of Contents
=================

   * [go-demo](#go-demo)
      * [Install pre-requiste tools](#install-pre-requiste-tools)
      * [Configure environment](#configure-environment)
      * [Run the demo](#run-the-demo)
   * [Under the hood](#under-the-hood)
      * [Build logging](#build-logging)
      * [Helm integration](#helm-integration)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# go-demo

Dummy project to demonstrate Kubernetes Draft

## Install pre-requiste tools

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Draft](https://draft.sh/)

## Configure environment

Create a minikube environmnent with an ingress controller

```
minikube start
minikube addons enable ingress
```

Install helm and configure draft

```
helm init
draft init 
eval $(minikube docker-env)
draft config set disable-push-warning 1
```

## Run the demo

Initialize the project

```
draft create
```

Run the build

```
draft up
```

Check the build history

```
$ draft history
BUILD_ID                  	CONTEXT_ID	CREATED_AT              	RELEASE
01CATRV0P9EYF8C7XJ9FCA2KJJ	903C5CC089	Wed Apr 11 17:33:38 2018	go-demo
```

To access the application, you can run a proxy:

```
$ draft connect
Connect to go:8080 on localhost:34921
[go]: + exec app
```

And see the output locally:

http://localhost:34921/Joe

## Expose the application via an Ingress

TODO

