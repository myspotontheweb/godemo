# go-demo

Dummy project to demonstrate Kubernetes Draft

## Install pre-requiste tools

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Draft](https://github.com/Azure/draft/blob/master/docs/install.md)
- [Stern](https://github.com/wercker/stern)

## Configure environment

```
minikube start
minikube addons enable registry
minikube addons enable ingress
helm init
draft init --auto-accept --ingress-enabled
```

Need entry in the hosts file to resolve application location

```
sudo su -
echo "$(minikube ip) go-demo.k8s.local" >> /etc/hosts
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

After build should be available via ingress

- http://go-demo.k8s.local/Joe

**Note:**

When using Draft v0.10.1, I encountered a bug [where an Ingress is not being created](https://github.com/Azure/draft/issues/336). The following work-around will patch the helm release. 

```
helm upgrade go-demo charts/go --set ingress.enabled=true --set basedomain=k8s.local
```

### Build logging

In another window you can monitor the build output

```
stern -n kube-system draftd
```
