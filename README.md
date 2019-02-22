# Namespace NetworkPolicy Metacontroller controller

Networkpolicy applied based on Namespace annotations

annotation example (these go on a service object):

```
  annotations:
    network-policy: 'true'
    network-policy.allow-namespace: red-dmz-infra,welcome
```

This controller uses the metacontroller framework.

# Deploy the metacontroller

```
oc adm new-project metacontroller
oc apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller-rbac.yaml
oc apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller.yaml
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

NAME                                                    POD-SELECTOR   AGE
namespace-np-controller-test-allow-from-red-dmz-infra   <none>         5m
namespace-np-controller-test-allow-from-welcome         <none>         5m
```