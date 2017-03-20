set -o errexit
set -o nounset
set -o pipefail

REPOS="apimachinery,client-go,apiserver,kube-aggregator,sample-apiserver"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    git checkout master
    git fetch origin
    git branch -f generated-by-scripts origin/master
    git push -f origin generated-by-scripts
done
cd $K1/../client-go
git checkout master
git branch -f release-2.0-generated-by-scripts origin/release-2.0
git push -f origin release-2.0-generated-by-scripts
