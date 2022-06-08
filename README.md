# reroll-script
Script to re-roll pods. Useful when unreachable.

### Requirements
kubectl, kubectx, and kubens.

### Usage
Use cluster name as optional argument. 
If argument is not passed, your current cluster will be used instead.
Use namespace as second optional argument. 
If second argument is not passed, the monitoring namespace will be used instead.

### Running
```
./targetDown.sh [CLUSTER] [NAMESPACE]
```

### Output

```
/ [main] sh reroll.sh uw2p-akp-b1    
Switched to context "uw2p-akp-b1".
Context "uw2p-akp-b1" modified.
Active namespace is "monitoring".
Getting prometheus-operator pods...
prometheus-operator-588c5bfcd4-78lhj     2/2     Running   0          38m
Getting prometheus-operator logs...
ts=2022-06-08T21:23:10.575617533Z caller=stdlib.go:89 ts="2022/06/08 21:23:10" caller="http: TLS handshake error from 127.0.0.1:39078" msg="remote error: tls: bad certificate"
.
.
.
ts=2022-06-08T21:23:35.604604203Z caller=stdlib.go:89 ts="2022/06/08 21:23:35" caller="http: TLS handshake error from 127.0.0.1:39460" msg="remote error: tls: bad certificate"
ts=2022-06-08T21:23:40.580725163Z caller=stdlib.go:89 ts="2022/06/08 21:23:40" caller="http: TLS handshake error from 127.0.0.1:39608" msg="remote error: tls: bad certificate"
Are you sure you want to rollout prometheus-operator-6948ccf56d-hsp2q? (y/n)y
Restarting the pods using rolling restart method...
deployment.apps/prometheus-operator restarted
Getting prometheus-operator pods...
prometheus-operator-588c5bfcd4-78lhj     0/2     ContainerCreating   0          1s
prometheus-operator-6948ccf56d-hsp2q     2/2     Running             0          23d
Waiting 30 seconds for pod restart...
Getting prometheus-operator pods...
prometheus-operator-588c5bfcd4-78lhj     2/2     Running   0          32s
Getting new rolled prometheus-operator logs...
level=info ts=2022-06-08T21:24:00.626287737Z caller=main.go:294 msg="Starting Prometheus Operator" version="(version=0.47.0, branch=refs/tags/pkg/client/v0.47.0, revision=539108b043e9ecc53c4e044083651e2ebfbd3492)"
level=info ts=2022-06-08T21:24:00.626337891Z caller=main.go:295 build_context="(go=go1.16.3, user=simonpasquier, date=20210413-15:45:09)"
level=info ts=2022-06-08T21:24:00.632076802Z caller=server.go:54 msg="enabling server side TLS"
level=info ts=2022-06-08T21:24:00.633603634Z caller=main.go:124 msg="Starting secure server on [::]:8080"
level=info ts=2022-06-08T21:24:16.076967566Z caller=operator.go:306 component=thanosoperator msg="connection established" cluster-version=v1.21.12-eks-a64ea69
level=info ts=2022-06-08T21:24:16.076983549Z caller=operator.go:416 component=prometheusoperator msg="connection established" cluster-version=v1.21.12-eks-a64ea69
level=info ts=2022-06-08T21:24:16.077003678Z caller=operator.go:315 component=thanosoperator msg="CRD API endpoints ready"
level=info ts=2022-06-08T21:24:16.077009786Z caller=operator.go:425 component=prometheusoperator msg="CRD API endpoints ready"
level=info ts=2022-06-08T21:24:16.077035378Z caller=operator.go:444 component=alertmanageroperator msg="connection established" cluster-version=v1.21.12-eks-a64ea69
level=info ts=2022-06-08T21:24:16.077062352Z caller=operator.go:453 component=alertmanageroperator msg="CRD API endpoints ready"
level=info ts=2022-06-08T21:24:18.82270519Z caller=operator.go:267 component=thanosoperator msg="successfully synced all caches"
level=info ts=2022-06-08T21:24:19.832768799Z caller=operator.go:355 component=prometheusoperator msg="successfully synced all caches"
level=info ts=2022-06-08T21:24:19.930124263Z caller=operator.go:1163 component=prometheusoperator msg="sync prometheus" key=monitoring/k8s
level=info ts=2022-06-08T21:24:20.123687026Z caller=operator.go:285 component=alertmanageroperator msg="successfully synced all caches"
level=info ts=2022-06-08T21:24:20.756030594Z caller=operator.go:1163 component=prometheusoperator msg="sync prometheus" key=monitoring/k8s
```
