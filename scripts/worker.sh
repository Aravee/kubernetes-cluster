echo "This is worker"
apt-get install -y sshpass
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@192.168.1.100:/etc/kubeadm_join_cmd.sh .
sh ./kubeadm_join_cmd.sh