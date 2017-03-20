set -o errexit
set -o nounset
set -o pipefail

cd $K1/../apiserver
git checkout master
git reset --hard 391c3232e9e5925ab24c1bdd8efa4092a44b58c4
git push -f origin master

cd $K1/../sample-apiserver
git checkout master
git reset --hard 1729664a9525380dfdba1815eb01eed0bf57c12b
git push -f origin master

cd $K1/../kube-aggregator
git checkout master
git reset --hard 81f3b27abb704192ea0866b06ea3dd8a86a10a14 
git push -f origin master

cd $K1/../apimachinery
git checkout master
git reset --hard 9a985094ad498bd42b236091b1c6193c2edcb87f
git push -f origin master

cd $K1/../client-go
git checkout master
git reset --hard 0b5e2de8597d21dfd83ae469836d76fd7002203e
git push -f origin master

cd $K1/../client-go
git checkout release-2.0
git reset --hard f7a4a7ac51370ace2582fa107565c9a7df2b3564
git push -f origin release-2.0
