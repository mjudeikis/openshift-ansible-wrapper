
Vagrant.require_version ">= 1.7.0"

disk = './vagrant/secondDisk.vdi'
Vagrant.configure(2) do |config|

  config.vm.box = "centos/7"
  config.vm.network :private_network, ip: "192.168.121.74"

  config.ssh.insert_key = true

  #add second disk for docker test. I use libvirt so if you use virtual box you might refactor this part
  config.vm.provider :libvirt do |libvirt|
        libvirt.cpus = 2
        libvirt.memory = 1024
        # XXX: WIP
        libvirt.storage :file,
            :type => 'qcow2'
  end
  
  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "site.yml"
    ansible.inventory_path = "inventory/test"
  end
end
