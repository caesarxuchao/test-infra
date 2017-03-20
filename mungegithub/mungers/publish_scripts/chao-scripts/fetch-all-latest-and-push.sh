set -o errexit
set -o nounset
set -o pipefail

REPOS="apimachinery,client-go,apiserver,kube-aggregator,sample-apiserver"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    git fetch upstream
    git checkout master
    git reset --hard upstream/master
    git push -f origin master
done

REPOS="apimachinery,apiserver,kube-aggregator,sample-apiserver"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    git branch -f release-1.6 upstream/release-1.6
    git push -f origin release-1.6
done

REPOS="client-go"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    git branch -f release-3.0 upstream/release-3.0
    git push -f origin release-3.0
done
