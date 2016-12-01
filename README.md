# helm-pod

Contains a Dockerfile that builds a container with [`helm`](https://github.com/kubernetes/helm) and [`kubectl`](http://kubernetes.io/docs/user-guide/kubectl-overview/) installed. This pod is meant to be an in-cluster way to run `helm` or `kubectl` commands from your local machine.

Select the options at the top of the file:
```bash
# Version for the kubectl cli
KUBECTL_VERSION=v1.4.6
# Version for the helm cli
HELM_VERSION=v2.0.0
# True builds docker image, false skips
BUILD=true
# True pushes image, false skips
PUSH=true
# True spins up a pod and attaches you to a shell session, false skips
ATTACH=true
# True deletes the kubectl and helm binaries
DELETE=true
```