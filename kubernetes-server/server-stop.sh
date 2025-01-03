DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/master
vagrant suspend

cd $DIR/worker1
vagrant suspend

cd $DIR/worker2
vagrant suspend

cd $DIR/rancher
vagrant suspend