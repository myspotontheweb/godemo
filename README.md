# go-demo

Dummy project to demonstrate Kubernetes Draft

## Install pre-requiste tools

- Minikube
- Kubectl
- Draft
- Stern

## Run demo

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
