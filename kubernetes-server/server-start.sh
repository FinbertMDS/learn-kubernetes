DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/master
vagrant resume

cd $DIR/worker1
vagrant resume

cd $DIR/worker2
vagrant resume