DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/master
vagrant destroy -f

cd $DIR/worker1
vagrant destroy -f

cd $DIR/worker2
vagrant destroy -f

kubectl config delete-cluster kubernetes
kubectl config delete-context kubernetes-admin@kubernetes
kubectl config unset users.kubernetes-admin
rm -f ~/.kube/config-mycluster