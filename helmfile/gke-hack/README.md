# GKE Hack

Hack to make gke \$\$ friendly

## fluentd-gcp-scaling-policy

https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-gcp

use ScalingPolicy to make fluentd stop hogging resources

## kube-dns hook

https://github.com/kubernetes-incubator/cluster-proportional-autoscaler#linear-mode

set preventSinglePointFailure to false since who need reliability
also since helm cannot replace existing resource yet we need the
presync hook to delete gce provided configmap
