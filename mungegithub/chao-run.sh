set -o errexit
set -o nounset
set -o pipefail

kubectl config use-context gke_chao1-149704_us-central1-a_munger-test

kubectl delete deployment --all
kubectl delete secret --all
kubectl delete configmap --all
export APP=publisher
export TARGET=kubernetes
export REPO=gcr.io/chao1-149704
make clean
make secret
kubectl create -f /usr/local/google/home/xuchao/go-workspace/src/k8s.io/test-infra/mungegithub/publisher/local.secret.yaml
kubectl create -f /usr/local/google/home/xuchao/go-workspace/src/k8s.io/test-infra/mungegithub/publisher/deployment/kubernetes/configmap.yaml
export READONLY=false
make deploy
