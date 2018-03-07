# go-demo

Dummy project to demonstrate Kubernetes Draft

## Install pre-requiste tools

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Draft](https://github.com/Azure/draft/blob/master/docs/install.md)
- [Stern](https://github.com/wercker/stern)

## Configure environment

Create a minikube environmnent with a registry and ingress controller

```
minikube start
minikube addons enable registry
minikube addons enable ingress
helm init
draft init --ingress-enabled --auto-accept
```

The ingress-enabled flag is [not working](https://github.com/Azure/draft/issues/336), making the following patch is necessary

```
kubectl patch deployment/draftd --type='json' \
-p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args/4", "value": "--ingress-enabled=true"}]' \
--namespace=kube-system
```

The basedomain can be set to use IP address of the minikube VM

```
kubectl patch deployment/draftd --type='json' \
-p="[{'op': 'replace', 'path': '/spec/template/spec/containers/0/args/3', 'value': '--basedomain=$(minikube ip).nip.io'}]" \
--namespace=kube-system
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

Once the build is completed, the application should be exposed via an Ingress

```
echo "http://go-demo.$(minikube ip).nip.io/Joe"
```


### Build logging

In another window you can monitor the build output

```
stern -n kube-system draftd
```
