Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [go-demo](#go-demo)
      * [Install pre-requiste tools](#install-pre-requiste-tools)
      * [Configure environment](#configure-environment)
      * [Run the demo](#run-the-demo)
      * [Other features](#other-features)
         * [Build logs](#build-logs)
      * [Bugs](#bugs)
         * [Expose the application via an Ingress](#expose-the-application-via-an-ingress)
         * [Watcher not working](#watcher-not-working)
   * [Draft and AWS](#draft-and-aws)
      * [Install Software](#install-software)
         * [Helm](#helm)
         * [AWS CLI](#aws-cli)
      * [Configure software](#configure-software)
         * [Create an ECR registry](#create-an-ecr-registry)
      * [Run demo](#run-demo)
         * [Spin up a local k8s cluster](#spin-up-a-local-k8s-cluster)
         * [Registry credentials](#registry-credentials)
         * [Generate Dockerfile and Helm chart](#generate-dockerfile-and-helm-chart)

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

If Draft supported the setting of overrides then the ingress could be enabled, but running helm as follows

```
helm install charts/go --set image.repository=go-demo --set image.tag=XXXX --set ingress.enabled=true --set basedomain=$(minikube ip).nip.io
```

### Watcher not working

Couple of open issues. This was working in v0.11.0

- [#341](https://github.com/Azure/draft/issues/341)
- [#3](https://github.com/Azure/draft/issues/3)

This a pity as we'd like to redeploy automatically upon code changes.

# Draft and AWS

The following section documents learnings in how to use draft with AWS infrastructure, specifically [AWS ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)

## Install Software

### Helm

```
VERSION=2.6.2

curl -LO https://storage.googleapis.com/kubernetes-helm/helm-$VERSION-linux-amd64.tar.gz
tar -zxvf helm-v$VERSION-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm-$VERSION
sudo ln -sf /usr/local/bin/helm-$VERSION /usr/local/bin/helm
```

### AWS CLI

```
sudo apt-get install python-pip
pip install awscli --upgrade --user
pip install awsenv --upgrade --user
```

Edit the bash settings to change path

```
export PATH=$PATH:~/.local/bin
```

Configure CLI

```
aws configure --profile devenv
```

NOTE:

> TODO: Need to document the IAM permissions for accessing ECR

## Configure software

### Create an ECR registry

To use our AWS profile

```
eval $(awsenv devenv)
```

Create an ECR repository

```
aws ecr create-repository --repository-name go-demo
```

List available repositories

```
aws ecr describe-repositories
```

## Run demo

### Spin up a local k8s cluster

```
minikube start
helm init
```

### Registry credentials

```
#
# Normal Docker hub login
#
docker login

#
# AWS ECR login
#
eval $(aws ecr get-login --no-include-email)
```

Setup credentials in cluster's "default" service account 

```
kubectl create secret generic dockerhub --type=kubernetes.io/dockerconfigjson --from-file .dockerconfigjson=$HOME/.docker/config.json
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "dockerhub"}]}'
```

Configure Draft to use ECR registry

```
draft init
draft config set registry $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com
``` 

### Generate Dockerfile and Helm chart

```
draft create
```

Deploy code

```
draft up
```