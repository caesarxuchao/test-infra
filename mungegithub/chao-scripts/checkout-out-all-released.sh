set -o errexit
set -o nounset
set -o pipefail

CHAO_ROOT=$(dirname "${BASH_SOURCE}")
source "${CHAO_ROOT}/init.sh"

IFS=',' read -a repos <<< "${REPOS}"
repo_count=${#repos[@]}
for (( i=0; i<${repo_count}; i++ )); do
    cd $K1/../"${repos[i]}"
    git checkout generated-by-scripts
    #git checkout master
done
