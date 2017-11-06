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

In another window you can monitor the build output

```
stern -n kube-system draftd
```
