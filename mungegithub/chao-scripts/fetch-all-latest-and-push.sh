set -o errexit
set -o nounset
set -o pipefail

CHAO_ROOT=$(dirname "${BASH_SOURCE}")
source "${CHAO_ROOT}/init.sh"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}

echo "=================="
echo "CHAO: safety check"
echo "=================="
# safety check
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    if [[ $(git config --get remote.origin.url) != *"caesarxuchao"* ]]; then
        echo "origin is not right, expect seeing caesarxuchao, got $(git config --get remote.origin.url)"
        exit 1
    fi
done

echo "=================="
echo "CHAO: sync masters"
echo "=================="
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    echo "CHAO: repo=${repos[i]}"
    git fetch upstream
    git checkout master
    git reset --hard upstream/master
    git push -f origin master
done

echo "=================="
echo "CHAO: sync release-1.6"
echo "=================="

REPOS="apimachinery,apiserver,kube-aggregator,sample-apiserver"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    echo "CHAO: repo=${repos[i]}"
    git branch -f release-1.6 upstream/release-1.6
    git push -f origin release-1.6
done

echo "=================="
echo "CHAO: sync release-1.7"
echo "=================="

REPOS="apimachinery"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    echo "CHAO: repo=${repos[i]}"
    git branch -f release-1.7 upstream/release-1.7
    git push -f origin release-1.7
done

echo "=================="
echo "CHAO: sync client-go release-3.0"
echo "=================="

REPOS="client-go"
IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    echo "CHAO: repo=${repos[i]}"
    git branch -f release-3.0 upstream/release-3.0
    git push -f origin release-3.0
done
