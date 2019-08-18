# Namespace NetworkPolicy Metacontroller controller

Networkpolicy applied based on Namespace annotations

annotation example (these go on a service object):

```
  annotations:
    network-zone: 'true'
    network-zone.allow-from-self: 'true'
    network-zone.allow-namespace: red-dmz-infra,welcome
```

`network-zone: 'true'`- enable network-policy

`network-zone.allow-from-self: 'true'` - allow traffic from within own namespace

`network-zone.allow-namespace: red-dmz-infra,welcome` - other project to allow traffic from (they must have a label `name=<project name>`)

This controller uses the metacontroller framework.

# Deploy the metacontroller

```
oc adm new-project metacontroller
oc apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller-rbac.yaml
oc apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller.yaml
```

Use local versions in this repo

```
oc adm new-project metacontroller
oc apply -f ./metacontroller-rbac.yaml
oc apply -f ./metacontroller.yaml
```

# Deploy the namespace controller
```
oc project metacontroller
oc create configmap namespace-np-controller --from-file=namespace-np-controller.jsonnet --dry-run -o yaml | oc apply --force -f-
oc apply -f namespace-np-controller.yaml
```

# Test

Create a test namespace

```
oc apply -f ./test-namespace.yaml
```

make sure a networkpolicy is created

```
oc get networkpolicy -n namespace-np-controller-test

NAME                       POD-SELECTOR   AGE
allow-from-red-dmz-infra   <none>         14s
allow-from-self            <none>         14s
allow-from-welcome         <none>         14s
```