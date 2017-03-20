set -o errexit
set -o nounset
set -o pipefail

# for test
kubectl delete deployment kubernetes-publisher
export APP=publisher
export TARGET=kubernetes
make clean
make deploy
