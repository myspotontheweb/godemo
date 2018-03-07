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

## Under the hood

One nice feature of Draft is that it is built on top of helm. The```draft up``` command will both build the docker image
and delploy it using helm.  Furthermore the server component of draft is also managed using helm.

```
$ helm ls
NAME   	REVISION	UPDATED                 	STATUS  	CHART         	NAMESPACE  
draft  	1       	Wed Mar  7 15:47:32 2018	DEPLOYED	draftd-v0.10.1	kube-system
go-demo	1       	Wed Mar  7 15:51:17 2018	DEPLOYED	go-v0.1.0     	default    
```

This fact is useful to know as it allows us to take a peek into the deployment and see the environment specific settings:

```
$ helm get values go-demo
basedomain: 192.168.99.100.nip.io
draft: go-demo
image:
  repository: 10.106.25.21/go-demo
  tag: afeab3e1a62d9748a37a2b2cbb067a4ca8bd708a
ingress:
  enabled: true
```

We can also take a peek at details such as the the YAML manifest created by the generated helm chart

```
$ helm get manifest go-demo

---
# Source: go/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: go-demo-go
  labels:
    chart: "go-v0.1.0"
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: golang
  selector:
    app: go-demo-go
---
# Source: go/templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: go-demo-go
  labels:
    draft: go-demo
    chart: "go-v0.1.0"
spec:
  replicas: 2
  template:
    metadata:
      labels:
        draft: go-demo
        app: go-demo-go
    spec:
      containers:
      - name: go
        image: "10.106.25.21/go-demo:afeab3e1a62d9748a37a2b2cbb067a4ca8bd708a"
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        resources:
            limits:
              cpu: 100m
              memory: 128Mi
            requests:
              cpu: 100m
              memory: 128Mi
---
# Source: go/templates/ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: go-demo-go
  labels:
    chart: "go-v0.1.0"
spec:
  rules:
  - host: go-demo.192.168.99.100.nip.io
    http:
      paths:
      - path: /
        backend:
          serviceName: go-demo-go
          servicePort: 80
```


