
git clone https://gerrit.fd.io/r/vpp
cd vpp

git remote add insa git@github.com:insa-unyte/vpp-srh-export.git
git fetch insa
git checkout <branch>

make build
