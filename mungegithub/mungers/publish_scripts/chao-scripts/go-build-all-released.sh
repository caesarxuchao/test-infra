#set -o errexit
set -o nounset
#set -o pipefail

REPOS="apimachinery,client-go,apiserver,kube-aggregator,sample-apiserver"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    go build ./...
done
