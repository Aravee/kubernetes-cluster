servers = [
    {
        :name => "k8s-master",
        :type => "master",
        :box => "ubuntu/xenial64",
        :box_version => "20180831.0.0",
        :eth1 => "192.168.1.100",
        :mem => "1024",
        :cpu => "2"
    },
    {
        :name => "k8s-node-1",
        :type => "node",
        :box => "ubuntu/xenial64",
        :box_version => "20180831.0.0",
        :eth1 => "192.168.1.101",
        :mem => "512",
        :cpu => "1"
    },
    {
        :name => "k8s-node-2",
        :type => "node",
        :box => "ubuntu/xenial64",
        :box_version => "20180831.0.0",
        :eth1 => "192.168.1.102",
        :mem => "512",
        :cpu => "1"
    }
]

Vagrant.configure("2") do |config|

    servers.each do |opts|
        config.vm.define opts[:name] do |config|

            config.vm.box = opts[:box]
            config.vm.box_version = opts[:box_version]
            config.vm.hostname = opts[:name]
            config.vm.network :private_network, ip: opts[:eth1]
            config.vm.synced_folder "/Users/aravindhana/brew/boxes/kubernetes-cluster/", "/vagrant_data"

            config.vm.provider "virtualbox" do |v|

                v.name = opts[:name]
            	v.customize ["modifyvm", :id, "--groups", "/My Minions"]
                v.customize ["modifyvm", :id, "--memory", opts[:mem]]
                v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]

            end

            if opts[:type] == "master"
                config.vm.provision  "ansible" do |ansible|
                    ansible.playbook = "playbooks/master/main.yml"
                end
            if opts[:type] == "worker"  
                config.vm.provision  "ansible" do |ansible|
                    ansible.playbook = "playbooks/worker/main.yml"
                    end
                end
            end        
        end

    end

end
