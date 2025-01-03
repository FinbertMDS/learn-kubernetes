DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/master
vagrant up

cd $DIR/worker1
vagrant up

cd $DIR/worker2
vagrant up

cd $DIR/rancher
vagrant up