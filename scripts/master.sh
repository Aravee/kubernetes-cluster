echo "This is master"
# ip of this box
IP_ADDR=`ifconfig enp0s8 | grep Mask | awk '{print $2}'| cut -f2 -d:`

# install k8s master
HOST_NAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=$IP_ADDR --apiserver-cert-extra-sans=$IP_ADDR  --node-name $HOST_NAME --pod-network-cidr=10.244.0.0/16

#copying credentials to regular user - vagrant
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

# install Flannel pod network addon
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
chmod +x /etc/kubeadm_join_cmd.sh

# required for setting up password less ssh between guest VMs
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart

# Installing Kubernetes Dashboard
# kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

# Creating Admin user for the Dashboard
# kubectl create -f /vagrant/config/kubernetes-dashboard-admin.yaml
# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') > /etc/kubedash.token
# echo "kubectl proxy --address="192.168.1.100" --accept-hosts='.*'" >> /home/vagrant/.bashrc