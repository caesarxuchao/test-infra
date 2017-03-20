set -o errexit
set -o nounset
set -o pipefail

kubectl config use-context gke_kubernetes-site_us-central1-a_utilicluster
kubectl delete deployment kubernetes-publisher || true
kubectl delete secret kubernetes-github-token || true
kubectl delete configmap kubernetes-publisher-config || true
export APP=publisher
export TARGET=kubernetes
#export REPO=gcr.io/kubernetes-site
make clean
make secret
kubectl create -f /usr/local/google/home/xuchao/go-workspace/src/k8s.io/test-infra/mungegithub/publisher/local.secret.yaml
kubectl create -f /usr/local/google/home/xuchao/go-workspace/src/k8s.io/test-infra/mungegithub/publisher/deployment/kubernetes/configmap.yaml
export READONLY=false
make deploy
