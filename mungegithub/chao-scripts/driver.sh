set -o errexit
set -o nounset
set -o pipefail

DIR="$(dirname $(readlink -f $0))"

#cd $K1/../apiserver
#"${DIR}"/publish_apiserver.sh master master

#cd $K1/../kube-aggregator
#"${DIR}"/publish_kube_aggregator.sh master master

cd $K1/../sample-apiserver
"${DIR}"/publish_sample_apiserver.sh master master
